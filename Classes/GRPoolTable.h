//
//  GRPoolTable.h
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 18/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRSprite.h"
#include "chipmunk.h"

@interface GRPoolTable : GRSprite {
 @private
  CGRect rect_;
}

- (id)initWithRect:(CGRect)rect body:(cpBody *)body space:(cpSpace *)space;

@end
