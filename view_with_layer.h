#import <Cocoa/Cocoa.h>

@class MyOpenGLLayer;

// Layer hosting view. Uses a CAOpenGLLayer to do drawing.
@interface ViewWithLayer : NSView {
  MyOpenGLLayer* layer_;
}

@end
