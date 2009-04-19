//
//  GRSprite.m
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 17/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GRSprite.h"
#import "Texture2D.h"

@implementation GRSprite

- (id)initWithFile:(NSString *)fileName {
  if (self = [super init]) {
    texture_ = [[Texture2D alloc] initWithImage:[UIImage imageNamed:fileName]];
  }
  
  return self;
}

- (void)dealloc {
  [texture_ release];
  
  [super dealloc];
}

- (void)draw {
  glPushMatrix();

  glTranslatef(self.posx, self.posy, 0.0);
    
  [texture_ drawAtPoint:CGPointZero];
  
  glPopMatrix();
}

@dynamic posx;
@dynamic posy;

@end
