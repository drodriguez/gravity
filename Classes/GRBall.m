//
//  GRBall.m
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 18/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GRBall.h"


@implementation GRBall

- (id)initAtPoint:(CGPoint)point space:(cpSpace *)space {
  if (self = [super initWithFile:@"ball.png"]) {
    body_ = cpBodyNew(1.0, cpMomentForCircle(1.0, 0.0, 10.0, cpvzero));
    body_->p = cpv(point.x, point.y);
    cpSpaceAddBody(space, body_);
    shape_ = cpCircleShapeNew(body_, 10.0, cpvzero);
    shape_->e = 0.75; shape_->u = 1.5;
    cpSpaceAddShape(space, shape_);
  }
  
  return self;
}

- (float)posx {
  return body_->p.x;
}

- (float)posy {
  return body_->p.y;
}

- (void)setPosx:(float)newx {
  // do nothing
}

- (void)setPosy:(float)newy {
  // do nothing
}

@end
