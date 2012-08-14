//
//  CDMPlusWindow.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMPlusWindow.h"

static CGFloat const kCDMPlusWindowCornerRadius = 4.f;

@implementation CDMPlusWindow
@synthesize parentWindow = _parentWindow;

#pragma mark - Initialization

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation {
    if ((self = [super
                 initWithContentRect:contentRect
                 styleMask:NSBorderlessWindowMask
                 backing:bufferingType
                 defer:deferCreation])) {
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setMovableByWindowBackground:NO];
    }
    return self;
}
@end

@implementation CDMPlusWindowContentView

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:kCDMPlusWindowCornerRadius yRadius:kCDMPlusWindowCornerRadius];
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor clearColor] endingColor:[NSColor colorWithDeviceWhite:0.f alpha:0.6f]];
    [gradient drawInBezierPath:path relativeCenterPosition:NSMakePoint(0, 0)];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    CDMPlusWindow *plusWindow = (CDMPlusWindow*)[self window];
    NSWindow *parentWindow = [plusWindow parentWindow];
    NSPoint where =  [parentWindow convertBaseToScreen:[theEvent locationInWindow]];
    NSPoint origin = [parentWindow frame].origin;
    // Now we loop handling mouse events until we get a mouse up event.
    while ((theEvent = [NSApp nextEventMatchingMask:NSLeftMouseDownMask|NSLeftMouseDraggedMask|NSLeftMouseUpMask untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:YES])&&([theEvent type]!=NSLeftMouseUp)) {
        // Set up a local autorelease pool for the loop to prevent buildup of temporary objects.
        @autoreleasepool {
            NSPoint now = [parentWindow convertBaseToScreen:[theEvent locationInWindow]];
            origin.x += now.x-where.x;
            origin.y += now.y-where.y;
            // Move the window by the mouse displacement since the last event.
            [parentWindow setFrameOrigin:origin];
            where = now;
        }
    }
}
@end