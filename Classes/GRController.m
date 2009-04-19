//
//  GRController.m
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 13/04/09.
//  Copyright 2009 Daniel Rodríguez Troitiño. All rights reserved.
//

#import "GRController.h"
#import "GRPoolTable.h"
#import "GRBall.h"

#define kAccelerometerFrequency 100.0
#define kRenderingFrequency 60.0
#define kFilteringFactor 0.1

@interface GRController ()

- (void)collisionBetween:(cpShape *)a
                     and:(cpShape *)b
                contacts:(cpContact *)contacts
             numContacts:(int)numContacts
              normalCoef:(cpFloat)normalCoef;

@end


static void GRCollisionPairFunc(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normalCoef, void *data) {
  GRController *controller = (GRController *)data;
  
  [controller collisionBetween:a
                           and:b
                      contacts:contacts
                   numContacts:numContacts
                    normalCoef:normalCoef]; 
}

@implementation GRController

- (void)awakeFromNib {
  staticBody = cpBodyNew(INFINITY, INFINITY);
  
  cpResetShapeIdCounter();
  
  space = cpSpaceNew();
  cpSpaceResizeStaticHash(space, 20.0, 999);
  space->elasticIterations = 5;
  space->gravity = cpv(0, -100);
  
  table = [[GRPoolTable alloc] initWithRect:CGRectMake(-160, -240, 320, 460)
                                       body:staticBody
                                      space:space];
  balls = [[NSMutableArray alloc] initWithCapacity:1];
  [balls addObject:[[[GRBall alloc] initAtPoint:CGPointMake(0, 0)
                                          space:space] autorelease]];
    
  [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
  [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

- (void)dealloc {
  [balls release];
  [table release];
  
  [super dealloc];
}

- (void)drawView:(GREAGLView *)view {
  [table draw];
  for (GRBall *ball in balls) {
    [ball draw];
  }
  
  space->gravity = cpv(98.1*accel[0], 98.1*accel[1]);
#if TARGET_IPHONE_SIMULATOR
  switch ([[UIDevice currentDevice] orientation]) {
    case UIDeviceOrientationUnknown:
    case UIDeviceOrientationPortrait:
    case UIDeviceOrientationFaceUp:
    case UIDeviceOrientationFaceDown:
      space->gravity = cpv(0, -100);
      break;
    case UIDeviceOrientationPortraitUpsideDown:
      space->gravity = cpv(0, 100);
      break;
    case UIDeviceOrientationLandscapeLeft:
      space->gravity = cpv(-100, 0);
      break;
    case UIDeviceOrientationLandscapeRight:
      space->gravity = cpv(100, 0);
      break;
  }
#endif
  cpSpaceStep(space, 1.0/60.0);
}

- (void)setupView:(GREAGLView *)view {
  CGRect rect = view.bounds;
  glViewport(0, 0, rect.size.width, rect.size.height);
  
  glEnable(GL_BLEND);
  glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glEnable(GL_TEXTURE_2D);  
    
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
  
  const GLfloat left = -160.0, right = 160.0;
  const GLfloat top = 240.0, bottom = -240.0;
  const GLfloat zNear = -1.0, zFar = 1.0;
  
  glOrthof(left, right, bottom, top, zNear, zFar);
	glTranslatef(0.5, 0.5, 0.0);
  
  glMatrixMode(GL_MODELVIEW);
}

- (void)collisionBetween:(cpShape *)a
                     and:(cpShape *)b
                contacts:(cpContact *)contacts
             numContacts:(int)numContacts
              normalCoef:(cpFloat)normalCoef {
  NSLog(@"collision!");
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
  //Use a basic low-pass filter to only keep the gravity in the accelerometer values
  accel[0] = acceleration.x * kFilteringFactor + accel[0] * (1.0 - kFilteringFactor);
  accel[1] = acceleration.y * kFilteringFactor + accel[1] * (1.0 - kFilteringFactor);
  accel[2] = acceleration.z * kFilteringFactor + accel[2] * (1.0 - kFilteringFactor);
}

@end
