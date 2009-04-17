//
//  GRBall.h
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 18/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRSprite.h"
#include "chipmunk.h"


@interface GRBall : GRSprite {
 @private
  cpBody *body_;
  cpShape *shape_;
}

- (id)initAtPoint:(CGPoint)point space:(cpSpace *)space;

@end
