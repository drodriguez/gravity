//
//  GRPoolTable.m
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 18/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GRPoolTable.h"

#define kMargin 30

@implementation GRPoolTable

- (id)initWithRect:(CGRect)rect body:(cpBody *)body space:(cpSpace *)space {
  if (self = [super initWithFile:@"pool-table.tiff"]) {
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
