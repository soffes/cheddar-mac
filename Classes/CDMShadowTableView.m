//
//  CDMShadowTableView.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMShadowTableView.h"

#define CDMShadowTableViewBottomColor [NSColor colorWithDeviceWhite:0.937f alpha:0.0f]
#define CDMShadowTableViewTopColor [NSColor colorWithDeviceWhite:0.937f alpha:0.8f]

@interface CDMShadowTableView ()
- (void)_redrawView;
@end

@implementation CDMShadowTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(_redrawView) name:NSWindowDidBecomeKeyNotification object:[self window]];
        [nc addObserver:self selector:@selector(_redrawView) name:NSWindowDidResignKeyNotification object:[self window]];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
	
    if ([self numberOfRows]) {
        NSRect rowRect = [self rectOfRow:[self numberOfRows] - 1];
        NSRect gradientRect = NSMakeRect(0.f, NSMaxY(rowRect), [self bounds].size.width, 3.f);
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:CDMShadowTableViewBottomColor endingColor:CDMShadowTableViewTopColor];
        [gradient drawInRect:gradientRect angle:270.f];
    }
}

- (void)_redrawView {
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
