//
//  CDMShadowTableView.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMShadowTableView.h"

#define CDMShadowTableViewBottomColor [NSColor colorWithDeviceWhite:0.937f alpha:0.0f]
#define CDMShadowTableViewTopColor [NSColor colorWithDeviceWhite:0.937f alpha:1.0f]

@implementation CDMShadowTableView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    if ([self numberOfRows]) {
        NSRect rowRect = [self rectOfRow:[self numberOfRows] - 1];
        NSRect gradientRect = NSMakeRect(0.f, NSMaxY(rowRect), [self bounds].size.width, 3.f);
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:CDMShadowTableViewBottomColor endingColor:CDMShadowTableViewTopColor];
        [gradient drawInRect:gradientRect angle:270.f];
    }
}

@end
