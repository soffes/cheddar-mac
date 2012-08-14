//
//  CDMWhiteOverlayView.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMWhiteOverlayView.h"

@implementation CDMWhiteOverlayView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithDeviceWhite:1.f alpha:0.9f] set];
    [NSBezierPath fillRect:[self bounds]];
}

@end
