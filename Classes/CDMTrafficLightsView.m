//
//  CDMTrafficLightsView.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-16.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTrafficLightsView.h"

static NSString* const kCDMTrafficLightsViewImageNameTrafficNormal = @"traffic-normal";
static NSString* const kCDMTrafficLightsViewImageNameTrafficClose = @"traffic-close";
static NSString* const kCDMTrafficLightsViewImageNameTrafficMinimize = @"traffic-minimize";
static NSString* const kCDMTrafficLightsViewImageNameTrafficZoom = @"traffic-zoom";
static NSString* const kCDMTrafficLightsViewImageNameTrafficClosePressed = @"traffic-close-pressed";
static NSString* const kCDMTrafficLightsViewImageNameTrafficMinimizePressed = @"traffic-minimize-pressed";
static NSString* const kCDMTrafficLightsViewImageNameTrafficZoomPressed = @"traffic-zoom-pressed";
static NSString* const kCDMTrafficLightsViewImageNameTrafficCloseGraphite = @"traffic-close-graphite";
static NSString* const kCDMTrafficLightsViewImageNameTrafficMinimizeGraphite = @"traffic-minimize-graphite";
static NSString* const kCDMTrafficLightsViewImageNameTrafficZoomGraphite = @"traffic-zoom-graphite";
static NSString* const kCDMTrafficLightsViewImageNameTrafficClosePressedGraphite = @"traffic-close-graphite-pressed";
static NSString* const kCDMTrafficLightsViewImageNameTrafficMinimizePressedGraphite = @"traffic-minimize-graphite-pressed";
static NSString* const kCDMTrafficLightsViewImageNameTrafficZoomPressedGraphite = @"traffic-zoom-graphite-pressed";

@interface CDMTrafficLightsView ()
- (NSButton*)_borderlessButtonWithRect:(NSRect)rect;
- (BOOL)_isGraphite;
- (void)_resetAlternateButtonImages;
@end

@implementation CDMTrafficLightsView {
    NSTrackingArea *_trackingArea;
    NSButton *_closeButton;
    NSButton *_minimizeButton;
    NSButton *_zoomButton;
}

- (id)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect])) {
        NSImage *trafficNormal = [NSImage imageNamed:kCDMTrafficLightsViewImageNameTrafficNormal];
        NSSize imageSize = [trafficNormal size];
        NSRect closeRect = NSMakeRect(0.f, 0.f, imageSize.width, imageSize.height);
        _closeButton = [self _borderlessButtonWithRect:closeRect];
        NSRect minimizeRect = closeRect;
        minimizeRect.origin.x += closeRect.size.width + kCDMWindowTrafficLightsSpacing;
        _minimizeButton = [self _borderlessButtonWithRect:minimizeRect];
        NSRect zoomRect = minimizeRect;
        zoomRect.origin.x += minimizeRect.size.width + kCDMWindowTrafficLightsSpacing;
        _zoomButton = [self _borderlessButtonWithRect:zoomRect];
        [self _resetAlternateButtonImages];
        [self addSubview:_closeButton];
        [self addSubview:_minimizeButton];
        [self addSubview:_zoomButton];
    }
    return self;
}

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
    NSUInteger styleMask = [newWindow styleMask];
    [_closeButton setEnabled:(styleMask & NSClosableWindowMask) == NSClosableWindowMask];
    [_minimizeButton setEnabled:(styleMask & NSMiniaturizableWindowMask) == NSMiniaturizableWindowMask];
    [_zoomButton setEnabled:(styleMask & NSResizableWindowMask) == NSResizableWindowMask];
    [_closeButton setTarget:newWindow];
    [_closeButton setAction:@selector(close)];
    [_minimizeButton setTarget:newWindow];
    [_minimizeButton setAction:@selector(miniaturize:)];
    [_zoomButton setTarget:newWindow];
    [_zoomButton setAction:@selector(zoom:)];
}

#pragma mark - Mouse Events

- (void)mouseEntered:(NSEvent *)theEvent
{
    BOOL graphite = [self _isGraphite];
	if ([_closeButton isEnabled]) {
        [_closeButton setImage:[NSImage imageNamed:graphite ? kCDMTrafficLightsViewImageNameTrafficCloseGraphite : kCDMTrafficLightsViewImageNameTrafficClose]];
    }
    if ([_minimizeButton isEnabled]) {
        [_minimizeButton setImage:[NSImage imageNamed:graphite ? kCDMTrafficLightsViewImageNameTrafficMinimizeGraphite : kCDMTrafficLightsViewImageNameTrafficMinimize]];
    }
	if ([_zoomButton isEnabled]) {
        [_zoomButton setImage:[NSImage imageNamed:graphite ? kCDMTrafficLightsViewImageNameTrafficZoomGraphite : kCDMTrafficLightsViewImageNameTrafficZoom]];
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    NSImage *trafficNormal = [NSImage imageNamed:kCDMTrafficLightsViewImageNameTrafficNormal];
    [_closeButton setImage:trafficNormal];
    [_minimizeButton setImage:trafficNormal];
    [_zoomButton setImage:trafficNormal];
}

#pragma mark - Private

- (NSButton*)_borderlessButtonWithRect:(NSRect)rect {
    NSButton *button = [[NSButton alloc] initWithFrame:rect];
    [button setBordered:NO];
    [button setButtonType:NSMomentaryChangeButton];
    [button setImage:[NSImage imageNamed:kCDMTrafficLightsViewImageNameTrafficNormal]];
    return button;
}


- (BOOL)_isGraphite {
    return ([NSColor currentControlTint] == NSGraphiteControlTint);
}


- (void)_resetAlternateButtonImages {
    BOOL graphite = [self _isGraphite];
    NSImage *close = [NSImage imageNamed:graphite ? kCDMTrafficLightsViewImageNameTrafficClosePressedGraphite : kCDMTrafficLightsViewImageNameTrafficClosePressed];
    NSImage *minimize = [NSImage imageNamed:graphite ? kCDMTrafficLightsViewImageNameTrafficMinimizePressedGraphite : kCDMTrafficLightsViewImageNameTrafficMinimizePressed];
    NSImage *zoom = [NSImage imageNamed:graphite ? kCDMTrafficLightsViewImageNameTrafficZoomPressedGraphite : kCDMTrafficLightsViewImageNameTrafficZoomPressed];
    [_closeButton setAlternateImage:close];
    [_minimizeButton setAlternateImage:minimize];
    [_zoomButton setAlternateImage:zoom];
}
@end
