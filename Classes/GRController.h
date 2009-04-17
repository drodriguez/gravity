//
//  GRController.h
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 13/04/09.
//  Copyright 2009 Daniel Rodríguez Troitiño. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GREAGLView.h"

#include "chipmunk.h"

@class GRPoolTable;

@interface GRController : NSObject <UIAccelerometerDelegate, GREAGLViewDelegate> {
  UIAccelerationValue accel[3];
  cpSpace *space;
  cpBody *staticBody;
  
  GRPoolTable *table;
  NSMutableArray *balls;
}

@end
