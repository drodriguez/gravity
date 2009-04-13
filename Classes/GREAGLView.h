//
//  GREAGLView.h
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 13/04/09.
//  Copyright Daniel Rodríguez Troitiño 2009. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@protocol GREAGLViewDelegate;

/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/
@interface GREAGLView : UIView {
    
@private
  /* The pixel dimensions of the backbuffer */
  GLint backingWidth;
  GLint backingHeight;
  
  EAGLContext *context;
  
  /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
  GLuint viewRenderbuffer, viewFramebuffer;
  
  /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
  GLuint depthRenderbuffer;
  
  NSTimer *animationTimer;
  NSTimeInterval animationInterval;
  
  id<GREAGLViewDelegate> delegate_;
  
  BOOL delegateSetup_;
}

@property(nonatomic, assign) IBOutlet id<GREAGLViewDelegate> delegate;
@property NSTimeInterval animationInterval;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;

@end

@protocol GREAGLViewDelegate<NSObject>

@required

- (void)drawView:(GREAGLView *)view;

@optional

- (void)setupView:(GREAGLView *)view;

@end
