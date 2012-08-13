//
//  CDMArchesWindow.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMArchesWindow.h"

static NSString* const kCDMArchesWindowImageNameArches = @"arches";
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

// Undocumented stuff from <http://stackoverflow.com/questions/6099338/how-to-know-if-window-is-minimizable-when-titlebar-was-double-clicked>
static NSString* const kAppleAquaColorVariant = @"AppleAquaColorVariant";
static int const kAppleGraphiteColorValue = 6;

static CGFloat const kCDMArchesWindowCornerRadius = 4.0f;
static CGFloat const kCDMArchesWindowTrafficLightsSpacing = 8.0f;
static CGFloat const kCDMArchesWindowTrafficLightsYInset = 8.0f;

@implementation CDMArchesWindowContentView

- (void)drawRect:(NSRect)dirtyRect
{
    NSImage *arches = [NSImage imageNamed:kCDMArchesWindowImageNameArches];
    NSColor *archesColor = [NSColor colorWithPatternImage:arches];
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
@end

@implementation CDMArchesWindow {
    NSButton *_closeButton;
    NSButton *_minimizeButton;
    NSButton *_zoomButton;
    CDMArchesWindowTrafficLightsView *_trafficLightContainer;
}

#pragma mark - Initialization

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation
{
    if ((self = [super
                 initWithContentRect:contentRect
                 styleMask:NSBorderlessWindowMask
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[[self contentView] superview] addSubview:_trafficLightContainer];
}

- (void)_registerNotifications
{
    // This notification gets sent when the user changes the color scheme (Aqua or Graphite)
    // Tip from <http://www.cocoabuilder.com/archive/cocoa/13836-notification-of-aqua-graphite-preference-changed.html#13835>
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_resetAlternateButtonImages)
                                                 name:NSControlTintDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSResponder

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

#pragma mark - CDMArchesWindowTrafficLightsViewDelegate

- (void)trafficLightsViewMouseEntered:(CDMArchesWindowTrafficLightsView*)view
{
    BOOL graphite = [self _isGraphite];
    [_closeButton setImage:[NSImage imageNamed:graphite ? kCDMArchesWindowImageNameTrafficCloseGraphite : kCDMArchesWindowImageNameTrafficClose]];
    [_minimizeButton setImage:[NSImage imageNamed:graphite ? kCDMArchesWindowImageNameTrafficMinimizeGraphite : kCDMArchesWindowImageNameTrafficMinimize]];
    [_zoomButton setImage:[NSImage imageNamed:graphite ? kCDMArchesWindowImageNameTrafficZoomGraphite : kCDMArchesWindowImageNameTrafficZoom]];
}

- (void)trafficLightsViewMouseExited:(CDMArchesWindowTrafficLightsView*)view
{
    NSImage *trafficNormal = [NSImage imageNamed:kCDMArchesWindowImageNameTrafficNormal];
    [_closeButton setImage:trafficNormal];
    [_minimizeButton setImage:trafficNormal];
    [_zoomButton setImage:trafficNormal];
}

#pragma mark - Private

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
    [_closeButton setAction:@selector(performClose:)];
    NSRect minimizeRect = closeRect;
    minimizeRect.origin.x += closeRect.size.width + kCDMArchesWindowTrafficLightsSpacing;
    _minimizeButton = [self _borderlessButtonWithRect:minimizeRect];
    [_minimizeButton setTarget:self];
    [_minimizeButton setAction:@selector(performMiniaturize:)];
    NSRect zoomRect = minimizeRect;
    zoomRect.origin.x += minimizeRect.size.width + kCDMArchesWindowTrafficLightsSpacing;
    _zoomButton = [self _borderlessButtonWithRect:zoomRect];
    [_zoomButton setTarget:self];
    [_zoomButton setAction:@selector(performZoom:)];
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults addSuiteNamed:NSGlobalDomain];
    NSNumber *color = [userDefaults objectForKey:kAppleAquaColorVariant];
    return ([color intValue] == kAppleGraphiteColorValue);
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
