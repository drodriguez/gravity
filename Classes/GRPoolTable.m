//
//  GRPoolTable.m
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 18/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GRPoolTable.h"
#import "Texture2D.h"
#include <OpenGLES/ES1/gl.h>

#define kMargin 30

@implementation GRPoolTable

- (id)initWithRect:(CGRect)rect body:(cpBody *)body space:(cpSpace *)space {
  if (self = [super initWithFile:@"pool-table.png"]) {
#if !TARGET_IPHONE_SIMULATOR
    GLint					saveName;
    glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
    glBindTexture(GL_TEXTURE_2D, texture_.name);
      
    GLint param[] = {0, 0, texture_.contentSize.width, texture_.contentSize.height};
    glTexParameteriv(GL_TEXTURE_2D, GL_TEXTURE_CROP_RECT_OES, param);
    glBindTexture(GL_TEXTURE_2D, saveName);
#endif    
    
    rect_ = rect;
    
    int x0 = rect_.origin.x;
    int y0 = rect_.origin.y;
    int x1 = x0 + rect_.size.width;
    int y1 = y0 + rect_.size.height;
    
    cpShape *shape;
    /* Superior wall */
    shape = cpSegmentShapeNew(body,
                              cpv(x0 + kMargin, y0 + kMargin),
                              cpv(x1 - kMargin, y0 + kMargin),
                              0.0f);
    shape->e = 0.99; shape->u = 1.0;
    cpSpaceAddStaticShape(space, shape);
    
    /* Inferior wall */
    shape = cpSegmentShapeNew(body,
                              cpv(x0 + kMargin, y1 - kMargin),
                              cpv(x1 - kMargin, y1 - kMargin),
                              0.0f);
    shape->e = 0.99; shape->u = 1.0;
    cpSpaceAddStaticShape(space, shape);
    
    /* Left wall */
    shape = cpSegmentShapeNew(body,
                              cpv(x0 + kMargin, y0 + kMargin),
                              cpv(x0 + kMargin, y1 - kMargin),
                              0.0f);
    shape->e = 0.99; shape->u = 1.0;
    cpSpaceAddStaticShape(space, shape);
    
    /* Right wall */
    shape = cpSegmentShapeNew(body,
                              cpv(x1 - kMargin, y0 + kMargin),
                              cpv(x1 - kMargin, y1 - kMargin),
                              0.0f);
    shape->e = 0.99; shape->u = 1.0;
    cpSpaceAddStaticShape(space, shape);
  }
  
  return self;
}

- (void)dealloc {
  // ??
  [super dealloc];
}

#if !TARGET_IPHONE_SIMULATOR
- (void)draw {
  glBindTexture(GL_TEXTURE_2D, texture_.name);
  glDrawTexiOES(0, 0, 0.0, 320, 460);
}
#endif

- (float)posx {
  return rect_.origin.x + rect_.size.width/2;
}

- (float)posy {
  return rect_.origin.y + rect_.size.height/2;
}

- (void)setPosx:(float)newx {
  // do nothing
}

- (void)setPosy:(float)newy {
  // do nothing
}

@end
