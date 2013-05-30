#import <Cocoa/Cocoa.h>

// Normal (not layer backed or layer hosting) view that uses a custom
// NSOpenGLContext to draw. Making this view layer backed or its parent
// view layer backed causes a GL_INVALID_FRAMEBUFFER_OPERATION error.
@interface SurfaceView : NSView {
  NSOpenGLContext* context_;
}

@end
