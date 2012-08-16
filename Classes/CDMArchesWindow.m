//
//  CDMArchesWindow.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMArchesWindow.h"
#import "NSColor+CDMAdditions.h"
#import <Carbon/Carbon.h>
#import <QuartzCore/QuartzCore.h>
#import "CDMTrafficLightsView.h"

static CGFloat const kCDMArchesWindowCornerRadius = 4.0f;
static NSInteger const kCDMArchesWindowShakeCount = 4;
static CGFloat const kCDMArchesWindowShakeDuration = 0.5f;
// factor that determines the distance the window moves when shaking
static CGFloat const kCDMArchesWindowShakeVigour = 0.05f; 

@implementation CDMArchesWindowContentView

- (void)drawRect:(NSRect)dirtyRect
{
    NSColor *archesColor = [NSColor cheddarArchesColor];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:kCDMArchesWindowCornerRadius yRadius:kCDMArchesWindowCornerRadius];
    [archesColor setFill];
    [path fill];
}

@end

@interface CDMArchesWindow ()
- (void)_createAndPositionTrafficLights;
- (void)_registerNotifications;
- (CAKeyframeAnimation *)_shakeAnimation:(NSRect)frame;
@end

@implementation CDMArchesWindow {
    CDMTrafficLightsView *_trafficLightContainer;
}

#pragma mark - Initialization

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation
{
    if ((self = [super
                 initWithContentRect:contentRect
                 styleMask:NSBorderlessWindowMask | windowStyle
                 backing:bufferingType
                 defer:deferCreation])) {
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setMovableByWindowBackground:YES];
        [self _createAndPositionTrafficLights];
        [self _registerNotifications];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[[self contentView] superview] addSubview:_trafficLightContainer];
    [self _repositionContentView];
}


- (void)_registerNotifications {
    // This notification gets sent when the user changes the color scheme (Aqua or Graphite)
    // Tip from <http://www.cocoabuilder.com/archive/cocoa/13836-notification-of-aqua-graphite-preference-changed.html#13835>
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(_resetAlternateButtonImages) name:NSControlTintDidChangeNotification object:nil];
    [nc addObserver:self selector:@selector(_repositionContentView) name:NSWindowDidResizeNotification object:self];
    [nc addObserver:self selector:@selector(_repositionContentView) name:NSWindowDidMoveNotification object:self];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)sendEvent:(NSEvent *)theEvent {
    // Detect Command + W to close window
    if (self.closeEnabled && [theEvent type] == NSKeyDown) {
        NSUInteger modifierFlags = [theEvent modifierFlags];
        unsigned short keyCode = [theEvent keyCode];
        if ((modifierFlags & NSCommandKeyMask) == NSCommandKeyMask && keyCode == kVK_ANSI_W) {
            [self close];
            return;
        }
    }
    [super sendEvent:theEvent];
}


#pragma mark - Actions

- (IBAction)shake:(id)sender {
    [self setAnimations:[NSDictionary dictionaryWithObject:[self _shakeAnimation:[self frame]] forKey:@"frameOrigin"]];
	[[self animator] setFrameOrigin:[self frame].origin];
}


// From <http://www.cimgf.com/2008/02/27/core-animation-tutorial-window-shake-effect/>
- (CAKeyframeAnimation *)_shakeAnimation:(NSRect)frame {
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
	int index;
	for (index = 0; index < kCDMArchesWindowShakeCount; ++index) {
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * kCDMArchesWindowShakeVigour, NSMinY(frame));
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * kCDMArchesWindowShakeVigour, NSMinY(frame));
	}
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = kCDMArchesWindowShakeDuration;
    return shakeAnimation;
}

#pragma mark - NSResponder

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (BOOL)canBecomeMainWindow
{
    return YES;
}

#pragma mark - Private

- (void)_repositionContentView
{
    NSView *contentView = [self contentView];
    NSRect windowFrame = [self frame];
    NSRect newFrame = [contentView frame];
    newFrame.size.height = windowFrame.size.height;
    [contentView setFrame:newFrame];
    [contentView setNeedsDisplay:YES];
}

- (void)_createAndPositionTrafficLights
{
    NSView *themeView = [[self contentView] superview];
    NSSize imageSize = [[NSImage imageNamed:@"traffic-normal"] size];
    NSRect trafficLightContainerRect = NSMakeRect(kCDMWindowTrafficLightsSpacing,  NSMaxY([themeView bounds]) - (kCDMWindowTrafficLightsYInset + imageSize.height), (imageSize.width * 3.f) + (kCDMWindowTrafficLightsSpacing * 2.f), imageSize.height);
    _trafficLightContainer = [[CDMTrafficLightsView alloc] initWithFrame:trafficLightContainerRect];
    [_trafficLightContainer setAutoresizingMask:NSViewMaxXMargin | NSViewMinYMargin];
}
@end
