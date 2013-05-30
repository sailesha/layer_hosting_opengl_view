#import "opengl_view.h"
#import <OpenGL/CGLMacro.h>

@implementation OpenGLView

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

- (id)initWithFrame:(NSRect)frameRect {
  if ((self = [super initWithFrame:frameRect
                       pixelFormat:[self basicPixelFormat]])) {
    [self setWantsLayer:YES];
    [NSTimer scheduledTimerWithTimeInterval:1.0 / 60.0
                                     target:self
                                   selector:@selector(onTimer:)
                                   userInfo:nil
                                    repeats:YES];
  }
  return self;
}

- (void)onTimer:(NSTimer*)timer {
  [self setNeedsDisplay:YES];
}

- (BOOL)isOpaque {
  return YES;
}

- (void)drawRect:(NSRect)rect {
  static int counter = 0;
  CGLContextObj cgl_ctx = (CGLContextObj)[[self openGLContext] CGLContextObj];
  if (++counter % 2)
    glClearColor(1, 0, 1, 1);
  else
    glClearColor(0, 1, 0, 1);
  glClear(GL_COLOR_BUFFER_BIT);
}

@end
