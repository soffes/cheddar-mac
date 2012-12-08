//
//  CDMTrafficLightsView.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-16.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTrafficLightsView.h"
#import <QuartzCore/QuartzCore.h>

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

static CGFloat const kCDMTrafficLightsViewAnimationDuration = 0.1f;

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

#pragma mark - NSObject

- (id)initWithFrame:(NSRect)frameRect {
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_resetAlternateButtonImages) name:NSControlTintDidChangeNotification object:nil];
    }
    return self;
}


- (void)updateTrackingAreas {
	[super updateTrackingAreas];
	if (_trackingArea) { [self removeTrackingArea:_trackingArea]; }
	NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
	_trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}


- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
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

- (void)mouseEntered:(NSEvent *)theEvent {
    [self _animateButtonsWithState:YES];
}


- (void)mouseExited:(NSEvent *)theEvent {
    [self _animateButtonsWithState:NO];
}


#pragma mark - Private

- (void)_animateButtonsWithState:(BOOL)state {
    BOOL graphite = [self _isGraphite];
    NSButton *newCloseButton = nil;
    NSButton *newMinButton = nil;
    NSButton *newZoomButton = nil;
    NSImage *trafficNormal = [NSImage imageNamed:kCDMTrafficLightsViewImageNameTrafficNormal];
	if ([_closeButton isEnabled]) {
        NSImage *closeImage = state ? [NSImage imageNamed:graphite ? kCDMTrafficLightsViewImageNameTrafficCloseGraphite : kCDMTrafficLightsViewImageNameTrafficClose] : trafficNormal;
        newCloseButton = [self _borderlessButtonWithRect:[_closeButton frame]];
        [newCloseButton setAlternateImage:[_closeButton alternateImage]];
        [newCloseButton setAlphaValue:0.f];
        [newCloseButton setImage:closeImage];
        [newCloseButton setAction:[_closeButton action]];
        [newCloseButton setTarget:[_closeButton target]];
        [self addSubview:newCloseButton];
    }
    if ([_minimizeButton isEnabled]) {
        NSImage *minImage = state ? [NSImage imageNamed:graphite ? kCDMTrafficLightsViewImageNameTrafficMinimizeGraphite : kCDMTrafficLightsViewImageNameTrafficMinimize] : trafficNormal;
        newMinButton = [self _borderlessButtonWithRect:[_minimizeButton frame]];
        [newMinButton setAlternateImage:[_minimizeButton alternateImage]];
        [newMinButton setAlphaValue:0.f];
        [newMinButton setImage:minImage];
        [newMinButton setAction:[_minimizeButton action]];
        [newMinButton setTarget:[_minimizeButton target]];
        [self addSubview:newMinButton];
    }
	if ([_zoomButton isEnabled]) {
        NSImage *zoomImage = state ? [NSImage imageNamed:graphite ? kCDMTrafficLightsViewImageNameTrafficZoomGraphite : kCDMTrafficLightsViewImageNameTrafficZoom] : trafficNormal;
        newZoomButton = [self _borderlessButtonWithRect:[_zoomButton frame]];
        [newZoomButton setAlternateImage:[_zoomButton alternateImage]];
        [newZoomButton setAlphaValue:0.f];
        [newZoomButton setImage:zoomImage];
        [newZoomButton setAction:[_zoomButton action]];
        [newZoomButton setTarget:[_zoomButton target]];
        [self addSubview:newZoomButton];
    }
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:kCDMTableViewAnimationDuration];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        if (newCloseButton) {
            [_closeButton removeFromSuperview];
            _closeButton = newCloseButton;
        }
        if (newMinButton) {
            [_minimizeButton removeFromSuperview];
            _minimizeButton = newMinButton;
        }
        if (newZoomButton) {
            [_zoomButton removeFromSuperview];
            _zoomButton = newZoomButton;
        }
    }];
    [[newCloseButton animator] setAlphaValue:1.f];
    [[newMinButton animator] setAlphaValue:1.f];
    [[newZoomButton animator] setAlphaValue:1.f];
    [NSAnimationContext endGrouping];
}


- (NSButton *)_borderlessButtonWithRect:(NSRect)rect {
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
