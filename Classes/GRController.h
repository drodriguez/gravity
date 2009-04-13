//
//  GRController.h
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 13/04/09.
//  Copyright 2009 Daniel Rodríguez Troitiño. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GREAGLView.h"

@interface GRController : NSObject <UIAccelerometerDelegate, GREAGLViewDelegate> {
  GREAGLView *view;
  UIAccelerationValue accel;
}

@end
