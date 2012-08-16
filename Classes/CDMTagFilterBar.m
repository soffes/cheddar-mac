//
//  CDMTagFilterBar.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-15.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTagFilterBar.h"

#define CDMTagFilterBarBottomColor [NSColor colorWithCalibratedRed:0.071 green:0.570 blue:0.801 alpha:1.000]
#define CDMTagFilterBarTopColor [NSColor colorWithCalibratedRed:0.082 green:0.654 blue:0.887 alpha:1.000]
#define CDMTagFilterBarInactiveTopColor [NSColor colorWithCalibratedRed:0.710 green:0.705 blue:0.710 alpha:1.000] 
#define CDMTagFilterBarInactiveBottomColor [NSColor colorWithCalibratedWhite:0.542 alpha:1.000]

@interface CDMTagFilterBar ()
- (void)_redrawView;
@end

@implementation CDMTagFilterBar
@synthesize delegate = _delegate;

- (id)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(_redrawView) name:NSWindowDidBecomeKeyNotification object:[self window]];
        [nc addObserver:self selector:@selector(_redrawView) name:NSWindowDidResignKeyNotification object:[self window]];
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)drawRect:(NSRect)dirtyRect {
    BOOL active = [[self window] isKeyWindow] && [NSApp isActive];
    NSColor *topColor = active ? CDMTagFilterBarTopColor : CDMTagFilterBarInactiveTopColor;
    NSColor *bottomColor = active ? CDMTagFilterBarBottomColor : CDMTagFilterBarInactiveBottomColor;
	NSColor *bottomInsetColor = active ? [NSColor colorWithCalibratedRed:0.370 green:0.687 blue:0.834 alpha:1.0] : [NSColor colorWithCalibratedWhite:0.585 alpha:1.0];
	NSColor *bottomBorderColor = active ? [NSColor colorWithCalibratedRed:0.083 green:0.427 blue:0.641 alpha:1.0] : [NSColor colorWithCalibratedWhite:0.4 alpha:1.0];
	
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:bottomColor endingColor:topColor];
    [gradient drawInRect:[self bounds] angle:90.f];

	CGSize size = self.bounds.size;
	if (active) {
		NSColor *topInsetColor = [NSColor colorWithCalibratedRed:0.453 green:0.770 blue:0.911 alpha:1.0];
		[topInsetColor setFill];
		[NSBezierPath fillRect:CGRectMake(0.0f, size.height - 1.0f, size.width, 1.0f)];
	}
	
	[bottomInsetColor setFill];
	[NSBezierPath fillRect:CGRectMake(0.0f, 1.0f, size.width, 1.0f)];

	[bottomBorderColor setFill];
	[NSBezierPath fillRect:CGRectMake(0.0f, 0.0f, size.width, 1.0f)];
}


- (void)mouseDown:(NSEvent *)theEvent {
    if ([self.delegate respondsToSelector:@selector(tagFilterBarClicked:)]) {
        [self.delegate tagFilterBarClicked:self];
    }
}


#pragma mark - Private

- (void)_redrawView {
    [self setNeedsDisplay:YES];
}

@end
