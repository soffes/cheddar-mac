//
//  CDMTagFilterBar.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-15.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTagFilterBar.h"
#import "NSColor+CDMAdditions.h"

@interface CDMTagFilterBar ()
- (void)_redrawView;
@end

@implementation CDMTagFilterBar

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - NSView

- (id)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(_redrawView) name:NSWindowDidBecomeKeyNotification object:[self window]];
        [nc addObserver:self selector:@selector(_redrawView) name:NSWindowDidResignKeyNotification object:[self window]];
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect {
    BOOL active = [[self window] isKeyWindow] && [NSApp isActive];
    NSColor *topColor = active ? [NSColor cheddarFilterBarTopColor] : [NSColor cheddarFilterBarInactiveTopColor];
    NSColor *bottomColor = active ? [NSColor cheddarFilterBarBottomColor] : [NSColor cheddarFilterBarInactiveBottomColor];
	NSColor *bottomInsetColor = active ? [NSColor cheddarFilterBarInsetColor] : [NSColor cheddarFilterBarInactiveInsetColor];
	NSColor *bottomBorderColor = active ? [NSColor cheddarFilterBarBottomBorderColor] : [NSColor cheddarFilterBarInactiveBottomBorderColor];
	
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


#pragma mark - NSControl

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
