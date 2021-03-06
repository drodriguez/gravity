//
//  GRAppDelegate.m
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 13/04/09.
//  Copyright Daniel Rodríguez Troitiño 2009. All rights reserved.
//

#import "GRAppDelegate.h"
#import "GREAGLView.h"

#include "chipmunk.h"

@implementation GRAppDelegate

@synthesize window;
@synthesize glView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  cpInitChipmunk();
  
#if TARGET_IPHONE_SIMULATOR
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
#endif
  
	glView.animationInterval = 1.0 / 60.0;
	[glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
#if TARGET_IPHONE_SIMULATOR
  [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
#endif
}


- (void)applicationWillResignActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / 5.0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / 60.0;
}


- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

@end
