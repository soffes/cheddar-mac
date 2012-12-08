//
//  CDMColorView.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-15.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMColorView.h"

@implementation CDMColorView

#pragma mark - Accessors

- (void)setColor:(NSColor *)color {
    if (_color != color) {
        _color = color;
        [self setNeedsDisplay:YES];
    }
}


#pragma mark - NSView

- (void)drawRect:(NSRect)dirtyRect {
    [self.color set];
    [NSBezierPath fillRect:[self bounds]];
}

@end
