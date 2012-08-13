//
//  CDMArchesWindow.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMArchesWindow.h"

static NSString* const kCDMArchesWindowImageNameArches = @"arches";
static CGFloat const kCDMArchesWindowCornerRadius = 4.0f;

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

@interface CDMArchesWindow ()
- (void)_createAndPositionTrafficLights;
@end

@implementation CDMArchesWindow

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
    }
    return self;
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

#pragma mark - Private

- (void)_createAndPositionTrafficLights
{
    
}
@end
