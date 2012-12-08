//
//  CDMArchesWindowContentView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 12/8/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMArchesWindowContentView.h"
#import "NSColor+CDMAdditions.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kCDMArchesWindowCornerRadius = 4.0f;

@implementation CDMArchesWindowContentView

#pragma mark - NSView

- (void)drawRect:(NSRect)dirtyRect {
    NSColor *archesColor = [NSColor cheddarArchesColor];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:kCDMArchesWindowCornerRadius yRadius:kCDMArchesWindowCornerRadius];
    [archesColor setFill];
    [path fill];
}

@end
