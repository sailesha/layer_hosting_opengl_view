#import "surface_view.h"
#import <OpenGL/CGLMacro.h>

@implementation SurfaceView

- (NSOpenGLPixelFormat*) basicPixelFormat {
  NSOpenGLPixelFormatAttribute  mAttrs []  = {
    NSOpenGLPFANoRecovery,
    NSOpenGLPFAColorSize, 32,
    NSOpenGLPFAAlphaSize, 8,
    NSOpenGLPFADepthSize, 16,
    NSOpenGLPFADoubleBuffer,
    NSOpenGLPFAAccelerated,
    0,
  };
  return [[[NSOpenGLPixelFormat alloc] initWithAttributes: mAttrs] autorelease];
}

- (id)initWithFrame:(NSRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [NSTimer scheduledTimerWithTimeInterval:1.0 / 60.0
                                     target:self
                                   selector:@selector(onTimer:)
                                   userInfo:nil
                                    repeats:YES];
  }
  return self;
}

- (void)dealloc {
  [context_ release];
  [super dealloc];
}

- (BOOL)isOpaque {
  return YES;
}

- (void)onTimer:(NSTimer*)timer {
  [self setNeedsDisplay:YES];
}

- (void)viewDidMoveToWindow {
  context_ = [[NSOpenGLContext alloc] initWithFormat:[self basicPixelFormat]
                                        shareContext:nil];
  [context_ setView:self];
  assert(context_);
}

- (void)drawRect:(NSRect)rect {
  static int counter = 0;
  [context_ makeCurrentContext];
  CGLContextObj cgl_ctx = (CGLContextObj)[context_ CGLContextObj];
  if (++counter % 2)
    glClearColor(1, 0, 1, 1);
  else
    glClearColor(0, 1, 0, 1);
  glClear(GL_COLOR_BUFFER_BIT);
  [context_ flushBuffer];

  // Fails with GL_INVALID_FRAMEBUFFER_OPERATION if view is layer backed or
  // a parent view is layer backed.
  assert(glGetError() == kCGLNoError);
}

@end
