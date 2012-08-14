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

static NSString* const kCDMArchesWindowImageNameTrafficNormal = @"traffic-normal";
static NSString* const kCDMArchesWindowImageNameTrafficClose = @"traffic-close";
static NSString* const kCDMArchesWindowImageNameTrafficMinimize = @"traffic-minimize";
static NSString* const kCDMArchesWindowImageNameTrafficZoom = @"traffic-zoom";
static NSString* const kCDMArchesWindowImageNameTrafficClosePressed = @"traffic-close-pressed";
static NSString* const kCDMArchesWindowImageNameTrafficMinimizePressed = @"traffic-minimize-pressed";
static NSString* const kCDMArchesWindowImageNameTrafficZoomPressed = @"traffic-zoom-pressed";
static NSString* const kCDMArchesWindowImageNameTrafficCloseGraphite = @"traffic-close-graphite";
static NSString* const kCDMArchesWindowImageNameTrafficMinimizeGraphite = @"traffic-minimize-graphite";
static NSString* const kCDMArchesWindowImageNameTrafficZoomGraphite = @"traffic-zoom-graphite";
static NSString* const kCDMArchesWindowImageNameTrafficClosePressedGraphite = @"traffic-close-graphite-pressed";
static NSString* const kCDMArchesWindowImageNameTrafficMinimizePressedGraphite = @"traffic-minimize-graphite-pressed";
static NSString* const kCDMArchesWindowImageNameTrafficZoomPressedGraphite = @"traffic-zoom-graphite-pressed";

static CGFloat const kCDMArchesWindowCornerRadius = 4.0f;
static CGFloat const kCDMArchesWindowTrafficLightsSpacing = 7.0f;
static CGFloat const kCDMArchesWindowTrafficLightsYInset = 8.0f;
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

@class CDMArchesWindowTrafficLightsView;
@protocol CDMArchesWindowTrafficLightsViewDelegate <NSObject>
- (void)trafficLightsViewMouseEntered:(CDMArchesWindowTrafficLightsView*)view;
- (void)trafficLightsViewMouseExited:(CDMArchesWindowTrafficLightsView*)view;
@end

@interface CDMArchesWindowTrafficLightsView : NSView
@property (nonatomic, assign) id<CDMArchesWindowTrafficLightsViewDelegate> delegate;
@end

@implementation CDMArchesWindowTrafficLightsView {
    NSTrackingArea *_trackingArea;
}
@synthesize delegate = _delegate;

- (void)updateTrackingAreas
{
	[super updateTrackingAreas];
	if (_trackingArea) { [self removeTrackingArea:_trackingArea]; }
	NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
	_trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
    [super viewWillMoveToWindow:newWindow];
    [self updateTrackingAreas];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    if ([self.delegate respondsToSelector:@selector(trafficLightsViewMouseEntered:)]) {
        [self.delegate trafficLightsViewMouseEntered:self];
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    if ([self.delegate respondsToSelector:@selector(trafficLightsViewMouseExited:)]) {
        [self.delegate trafficLightsViewMouseExited:self];
    }
}
@end

@interface CDMArchesWindow ()
- (void)_createAndPositionTrafficLights;
- (NSButton*)_borderlessButtonWithRect:(NSRect)rect;
- (BOOL)_isGraphite;
- (void)_resetAlternateButtonImages;
- (void)_registerNotifications;
- (CAKeyframeAnimation *)_shakeAnimation:(NSRect)frame;
@end

@implementation CDMArchesWindow {
    NSButton *_closeButton;
    NSButton *_minimizeButton;
    NSButton *_zoomButton;
    CDMArchesWindowTrafficLightsView *_trafficLightContainer;
}
@synthesize closeEnabled = _closeEnabled;
@synthesize minimizeEnabled = _minimizeEnabled;
@synthesize zoomEnabled = _zoomEnabled;

#pragma mark - Initialization

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation
{
    if ((self = [super
                 initWithContentRect:contentRect
                 styleMask:NSBorderlessWindowMask | NSTitledWindowMask
                 backing:bufferingType
                 defer:deferCreation])) {
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setMovableByWindowBackground:YES];
        [self _createAndPositionTrafficLights];
        [self _registerNotifications];
        
        // Set default values
        self.zoomEnabled = NO;
        self.minimizeEnabled = NO;
        self.closeEnabled = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[[self contentView] superview] addSubview:_trafficLightContainer];
    [self _repositionContentView];
}

- (void)_registerNotifications
{
    // This notification gets sent when the user changes the color scheme (Aqua or Graphite)
    // Tip from <http://www.cocoabuilder.com/archive/cocoa/13836-notification-of-aqua-graphite-preference-changed.html#13835>
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(_resetAlternateButtonImages) name:NSControlTintDidChangeNotification object:nil];
    [nc addObserver:self selector:@selector(_repositionContentView) name:NSWindowDidResizeNotification object:self];
    [nc addObserver:self selector:@selector(_repositionContentView) name:NSWindowDidMoveNotification object:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sendEvent:(NSEvent *)theEvent
{
    // Detect Command + W to close window
    if ([theEvent type] == NSKeyDown) {
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

- (IBAction)shake:(id)sender
{
    [self setAnimations:[NSDictionary dictionaryWithObject:[self _shakeAnimation:[self frame]] forKey:@"frameOrigin"]];
	[[self animator] setFrameOrigin:[self frame].origin];
}

// From <http://www.cimgf.com/2008/02/27/core-animation-tutorial-window-shake-effect/>

- (CAKeyframeAnimation *)_shakeAnimation:(NSRect)frame
{
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


#pragma mark - Accessors

- (void)setCloseEnabled:(BOOL)closeEnabled
{
    _closeEnabled = closeEnabled;
    [_closeButton setEnabled:closeEnabled];
}

- (void)setMinimizeEnabled:(BOOL)minimizeEnabled
{
    _minimizeEnabled = minimizeEnabled;
    [_minimizeButton setEnabled:minimizeEnabled];
}

- (void)setZoomEnabled:(BOOL)zoomEnabled
{
    _zoomEnabled = zoomEnabled;
    [_zoomButton setEnabled:zoomEnabled];
}

#pragma mark - NSResponder

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (BOOL)canBecomeMainWindow
{
    return YES;
}

#pragma mark - CDMArchesWindowTrafficLightsViewDelegate

- (void)trafficLightsViewMouseEntered:(CDMArchesWindowTrafficLightsView*)view
{
    BOOL graphite = [self _isGraphite];
    if (self.closeEnabled) {
        [_closeButton setImage:[NSImage imageNamed:graphite ? kCDMArchesWindowImageNameTrafficCloseGraphite : kCDMArchesWindowImageNameTrafficClose]];
    }
    if (self.minimizeEnabled) {
        [_minimizeButton setImage:[NSImage imageNamed:graphite ? kCDMArchesWindowImageNameTrafficMinimizeGraphite : kCDMArchesWindowImageNameTrafficMinimize]];
    }
    if (self.zoomEnabled) {
        [_zoomButton setImage:[NSImage imageNamed:graphite ? kCDMArchesWindowImageNameTrafficZoomGraphite : kCDMArchesWindowImageNameTrafficZoom]];
    }
}

- (void)trafficLightsViewMouseExited:(CDMArchesWindowTrafficLightsView*)view
{
    NSImage *trafficNormal = [NSImage imageNamed:kCDMArchesWindowImageNameTrafficNormal];
    [_closeButton setImage:trafficNormal];
    [_minimizeButton setImage:trafficNormal];
    [_zoomButton setImage:trafficNormal];
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
    NSImage *trafficNormal = [NSImage imageNamed:kCDMArchesWindowImageNameTrafficNormal];
    NSSize imageSize = [trafficNormal size];
    NSRect trafficLightContainerRect = NSMakeRect(kCDMArchesWindowTrafficLightsSpacing,  NSMaxY([themeView bounds]) - (kCDMArchesWindowTrafficLightsYInset + imageSize.height), (imageSize.width * 3.f) + (kCDMArchesWindowTrafficLightsSpacing * 2.f), imageSize.height);
    _trafficLightContainer = [[CDMArchesWindowTrafficLightsView alloc] initWithFrame:trafficLightContainerRect];
    _trafficLightContainer.delegate = (id)self;
    [_trafficLightContainer setAutoresizingMask:NSViewMaxXMargin | NSViewMinYMargin];
    NSRect closeRect = NSMakeRect(0.f, 0.f, imageSize.width, imageSize.height);
    _closeButton = [self _borderlessButtonWithRect:closeRect];
    [_closeButton setTarget:self];
    [_closeButton setAction:@selector(close)];
    [_closeButton setEnabled:self.closeEnabled];
    NSRect minimizeRect = closeRect;
    minimizeRect.origin.x += closeRect.size.width + kCDMArchesWindowTrafficLightsSpacing;
    _minimizeButton = [self _borderlessButtonWithRect:minimizeRect];
    [_minimizeButton setTarget:self];
    [_minimizeButton setAction:@selector(miniaturize:)];
    [_minimizeButton setEnabled:self.minimizeEnabled];
    NSRect zoomRect = minimizeRect;
    zoomRect.origin.x += minimizeRect.size.width + kCDMArchesWindowTrafficLightsSpacing;
    _zoomButton = [self _borderlessButtonWithRect:zoomRect];
    [_zoomButton setTarget:self];
    [_zoomButton setAction:@selector(zoom:)];
    [_zoomButton setEnabled:self.zoomEnabled];
    [self _resetAlternateButtonImages];
    [_trafficLightContainer addSubview:_closeButton];
    [_trafficLightContainer addSubview:_minimizeButton];
    [_trafficLightContainer addSubview:_zoomButton];
}

- (NSButton*)_borderlessButtonWithRect:(NSRect)rect
{
    NSButton *button = [[NSButton alloc] initWithFrame:rect];
    [button setBordered:NO];
    [button setButtonType:NSMomentaryChangeButton];
    [button setImage:[NSImage imageNamed:kCDMArchesWindowImageNameTrafficNormal]];
    return button;
}

- (BOOL)_isGraphite
{
    return ([NSColor currentControlTint] == NSGraphiteControlTint);
}

- (void)_resetAlternateButtonImages;
{
    BOOL graphite = [self _isGraphite];
    NSImage *close = [NSImage imageNamed:graphite ? kCDMArchesWindowImageNameTrafficClosePressedGraphite : kCDMArchesWindowImageNameTrafficClosePressed];
    NSImage *minimize = [NSImage imageNamed:graphite ? kCDMArchesWindowImageNameTrafficMinimizePressedGraphite : kCDMArchesWindowImageNameTrafficMinimizePressed];
    NSImage *zoom = [NSImage imageNamed:graphite ? kCDMArchesWindowImageNameTrafficZoomPressedGraphite : kCDMArchesWindowImageNameTrafficZoomPressed];
    [_closeButton setAlternateImage:close];
    [_minimizeButton setAlternateImage:minimize];
    [_zoomButton setAlternateImage:zoom];
}
@end
