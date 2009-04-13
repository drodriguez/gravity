//
//  GRAppDelegate.h
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 13/04/09.
//  Copyright Daniel Rodríguez Troitiño 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GREAGLView;

@interface GRAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GREAGLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GREAGLView *glView;

@end

