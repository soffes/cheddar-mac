//
//  CDMPlusDialogView.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMPlusDialogView.h"
#import "NSColor+CDMAdditions.h"

#define kCDMPlusDialogViewShadowOffset NSMakeSize(0.f, -3.f)
#define kCDMPlusDialogViewShadowColor [NSColor colorWithDeviceWhite:0.f alpha:0.3f]

static CGFloat const kCDMPlusDialogViewCornerRadius = 6.f;
static CGFloat const kCDMPlusDialogViewShadowBlurRadius = 4.f;

@implementation CDMPlusDialogView

- (void)drawRect:(NSRect)dirtyRect {
    CGFloat blurRadius = kCDMPlusDialogViewShadowBlurRadius;
    NSSize offset = kCDMPlusDialogViewShadowOffset;
    NSRect drawingRect = NSInsetRect([self bounds], blurRadius, blurRadius);
    drawingRect.origin.y -= offset.height;
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:drawingRect xRadius:kCDMPlusDialogViewCornerRadius yRadius:kCDMPlusDialogViewCornerRadius];
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor:kCDMPlusDialogViewShadowColor];
    [shadow setShadowBlurRadius:blurRadius];
    [shadow setShadowOffset:offset];
    [shadow set];
    [[NSColor cheddarArchesColor] set];
    [path fill];
}

@end
