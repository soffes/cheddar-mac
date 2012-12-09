//
//  CDMListTableRowView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/2/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMListTableRowView.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMListTableRowView

- (void)drawBackgroundInRect:(NSRect)dirtyRect {
	CGRect rect = self.bounds;
	
	[[NSColor whiteColor] setFill];
	[NSBezierPath fillRect:rect];
	
	CGRect separatorRect = rect;
	separatorRect.origin.y = separatorRect.size.height - 1.0f;
	separatorRect.size.height = 1.0f;
	
	[[NSColor cheddarCellSeparatorColor] set];
	[NSBezierPath fillRect:separatorRect];
	
	NSTableCellView *cellView = nil;
	if (self.numberOfColumns > 0 && (cellView = [self viewAtColumn:0])) {
		cellView.backgroundStyle = NSBackgroundStyleLight;
	}
}


- (void)drawSelectionInRect:(NSRect)dirtyRect {
	CGRect rect = self.bounds;
	rect.size.height -= 1.0f;
	
	NSColor *topColor = self.emphasized ? [NSColor cheddarFilterBarTopColor] : [NSColor cheddarFilterBarInactiveTopColor];
	NSColor *bottomColor = self.emphasized ? [NSColor cheddarFilterBarBottomColor] : [NSColor cheddarFilterBarInactiveBottomColor];
	NSColor *bottomBorderColor = self.emphasized ? [NSColor cheddarFilterBarBottomBorderColor] : [NSColor cheddarFilterBarInactiveBottomBorderColor];

	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:topColor endingColor:bottomColor];
	[gradient drawInRect:rect angle:90.0f];
	
	CGRect separatorRect = self.bounds;
	separatorRect.origin.y = separatorRect.size.height - 1.0f;
	separatorRect.size.height = 1.0f;
	
	[bottomBorderColor setFill];
	[NSBezierPath fillRect:separatorRect];
	
	NSTableCellView *cellView = nil;
	if (self.numberOfColumns > 0 && (cellView = [self viewAtColumn:0])) {
		cellView.backgroundStyle = NSBackgroundStyleDark;
	}
}


- (BOOL)isEmphasized {
    return [[self window] isKeyWindow] && [NSApp isActive];
}

@end
