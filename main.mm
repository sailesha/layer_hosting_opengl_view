#import <Cocoa/Cocoa.h>
#import "opengl_view.h"
#import "surface_view.h"
#import "view_with_layer.h"
#include "util.h"

@interface MyView : NSView
@end
@implementation MyView
- (void)drawRect:(NSRect)rect {
  [[NSColor redColor] set];
  NSRectFill([self bounds]);
}
@end

int main (int argc, const char * argv[]) {
  assert(argc == 2);
  int selection = atoi(argv[1]);

  ScopedPool pool;
  [NSApplication sharedApplication];

  NSRect rect = NSMakeRect(0, 0, 800, 400);
  NSWindow* window =
      [[[NSWindow alloc] initWithContentRect:rect
                                   styleMask:NSTitledWindowMask
                                     backing:NSBackingStoreBuffered
                                       defer:NO] autorelease];
  [window center];
  [window makeKeyAndOrderFront:nil];
  [window retain];

  NSView* content_view = [window contentView];
  NSView* hosting_view = [[NSView alloc] initWithFrame:rect];
  if (selection != 0)
    [hosting_view setWantsLayer:YES];
  [content_view addSubview:hosting_view];

  id rendering_view = nil;
  switch (selection) {
    case 0:
      // Normal (not layer backed or layer hosting) view that uses a custom
      // NSOpenGLContext to draw. Making this view layer backed or its parent
      // view layer backed causes a GL_INVALID_FRAMEBUFFER_OPERATION error.
      rendering_view = [[SurfaceView alloc] initWithFrame:rect];
      break;
    case 1:
      // Layer backed NSOpenGLView.
      rendering_view = [[OpenGLView alloc] initWithFrame:rect];
      break;
    case 2:
      // Use a layer hosting view.
      rendering_view = [[ViewWithLayer alloc] initWithFrame:rect];
      break;
    default:
      assert(false);
      break;
  }
  [hosting_view addSubview:rendering_view];

  MyView* overlapping_view =
      [[MyView alloc] initWithFrame:NSMakeRect(300, 100, 200, 200)];
  [hosting_view addSubview:overlapping_view];

  [NSApp run];
  return 0;
}
