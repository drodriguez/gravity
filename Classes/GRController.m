//
//  GRController.m
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 13/04/09.
//  Copyright 2009 Daniel Rodríguez Troitiño. All rights reserved.
//

#import "GRController.h"

#define kAccelerometerFrequency 100.0
#define kRenderingFrequency 60.0
#define kFilteringFactor 0.1

#define D2R(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

@implementation GRController

- (void)drawView:(GREAGLView *)view {
  const GLfloat squareVertices[] = {
      -0.5f, -0.5f,
      0.5f,  -0.5f,
      -0.5f,  0.5f,
      0.5f,   0.5f,
  };
  const GLubyte squareColors[] = {
      255, 255,   0, 255,
      0,   255, 255, 255,
      0,     0,   0,   0,
      255,   0, 255, 255,
  };
  
  CGRect rect = view.bounds;
  glViewport(0, 0, rect.size.width, rect.size.height);
  
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, -1.0f, 1.0f);
  glMatrixMode(GL_MODELVIEW);
  glRotatef(3.0f, 0.0f, 0.0f, 1.0f);
  
  glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT);
  
  glVertexPointer(2, GL_FLOAT, 0, squareVertices);
  glEnableClientState(GL_VERTEX_ARRAY);
  glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
  glEnableClientState(GL_COLOR_ARRAY);
  
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

/* - (void)setupView:(GREAGLView *)view {
  
} */

@end
