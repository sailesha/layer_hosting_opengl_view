#import "view_with_layer.h"
#import <OpenGL/CGLMacro.h>

@interface MyOpenGLLayer : CAOpenGLLayer {
}

@end

@implementation MyOpenGLLayer

- (void)drawInCGLContext:(CGLContextObj)glContext
             pixelFormat:(CGLPixelFormatObj)pixelFormat
            forLayerTime:(CFTimeInterval)timeInterval
             displayTime:(const CVTimeStamp*)timeStamp {
  static int counter = 0;
  CGLContextObj cgl_ctx = glContext;
  if (++counter % 2)
    glClearColor(1, 0, 1, 1);
  else
    glClearColor(0, 1, 0, 1);
  glClear(GL_COLOR_BUFFER_BIT);
}

@end

@implementation ViewWithLayer

- (id)initWithFrame:(NSRect)frameRect {
  if ((self = [super initWithFrame:frameRect])) {
    layer_ = [[MyOpenGLLayer alloc] init];
    [layer_ setAsynchronous:YES];
    [layer_ setDelegate:self];
    [self setLayer:layer_];
    [self setWantsLayer:YES];
  }
  return self;
}

- (BOOL)isOpaque {
  return YES;
}

- (void)dealloc {
  [layer_ release];
  [super dealloc];
}

@end
