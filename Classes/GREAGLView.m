//
//  GREAGLView.m
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 13/04/09.
//  Copyright Daniel Rodríguez Troitiño 2009. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "GREAGLView.h"

#define USE_DEPTH_BUFFER 0

// A class extension to declare private methods
@interface GREAGLView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (id)initGLES;
- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end


@implementation GREAGLView

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;


// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self = [self initGLES];
  }
  
  return self;
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
  if ((self = [super initWithCoder:coder])) {
    self = [self initGLES];
  }
  
  return self;
}

- (id)initGLES {
  // Get the layer
  CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
  
  eaglLayer.opaque = YES;
  eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                                  kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                  nil];
  
  context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
  if (!context ||
      ![EAGLContext setCurrentContext:context] ||
      ![self createFramebuffer]) {
    [self release];
    return nil;
  }
  
  animationInterval = 1.0 / 60.0;
  
  return self;
}

- (id<GREAGLViewDelegate>)delegate {
  return delegate_;
}

- (void)setDelegate:(id<GREAGLViewDelegate>)newDelegate {
  delegate_ = newDelegate;
  delegateSetup_ = ![delegate_ respondsToSelector:@selector(setupView:)];
}

//- (void)drawView {
//    
//    // Replace the implementation of this method to do your own custom drawing
//    
//    const GLfloat squareVertices[] = {
//        -0.5f, -0.5f,
//        0.5f,  -0.5f,
//        -0.5f,  0.5f,
//        0.5f,   0.5f,
//    };
//    const GLubyte squareColors[] = {
//        255, 255,   0, 255,
//        0,   255, 255, 255,
//        0,     0,   0,   0,
//        255,   0, 255, 255,
//    };
//    
//    [EAGLContext setCurrentContext:context];
//    
//    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
//    glViewport(0, 0, backingWidth, backingHeight);
//    
//    glMatrixMode(GL_PROJECTION);
//    glLoadIdentity();
//    glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, -1.0f, 1.0f);
//    glMatrixMode(GL_MODELVIEW);
//    glRotatef(3.0f, 0.0f, 0.0f, 1.0f);
//    
//    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
//    glClear(GL_COLOR_BUFFER_BIT);
//    
//    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
//    glEnableClientState(GL_COLOR_ARRAY);
//    
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//    
//    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
//    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
//}


- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}


- (void)startAnimation {
  self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}


- (void)stopAnimation {
  self.animationTimer = nil;
}


- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}


- (void)setAnimationInterval:(NSTimeInterval)interval {
    
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}

- (void)drawView {
  [EAGLContext setCurrentContext:context];
  
  if (!delegateSetup_) {
    [delegate_ setupView:self];
    delegateSetup_ = YES;
  }
  
  glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
  
  [delegate_ drawView:self];
  
  glBindFramebufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
  [context presentRenderbuffer:GL_RENDERBUFFER_OES];
  
  GLenum err = glGetError();
  if (err)
    NSLog(@"%x error", err);
}

- (void)dealloc {
  [self stopAnimation];
    
  if ([EAGLContext currentContext] == context) {
    [EAGLContext setCurrentContext:nil];
  }
    
  [context release];
  context = nil;
  
  
  [super dealloc];
}

@end
