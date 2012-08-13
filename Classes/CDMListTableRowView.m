//
//  CDMListTableRowView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/2/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMListTableRowView.h"

@interface CDMListTableRowView ()
@property (nonatomic, strong) NSColorList *colorList;
@end

@implementation CDMListTableRowView

@synthesize colorList = _colorList;

- (id)initWithFrame:(NSRect)frameRect {
	if ((self = [super initWithFrame:frameRect])) {
		self.colorList = [[NSColorList alloc] initWithName:NSStringFromClass([self class])];
		[self.colorList setColor:[NSColor colorWithCalibratedWhite:0.926 alpha:1.000] forKey:@"border"];

		[self.colorList setColor:[NSColor colorWithCalibratedRed:0.082 green:0.654 blue:0.887 alpha:1.000] forKey:@"selectedTop"];
		[self.colorList setColor:[NSColor colorWithCalibratedRed:0.071 green:0.570 blue:0.801 alpha:1.000] forKey:@"selectedBottom"];
		[self.colorList setColor:[NSColor colorWithCalibratedRed:0.058 green:0.458 blue:0.700 alpha:1.000] forKey:@"selectedBorder"];
		
		[self.colorList setColor:[NSColor colorWithCalibratedRed:0.710 green:0.705 blue:0.710 alpha:1.000] forKey:@"selectedTopUnemphasized"];
		[self.colorList setColor:[NSColor colorWithCalibratedWhite:0.542 alpha:1.000] forKey:@"selectedBottomUnemphasized"];
		[self.colorList setColor:[NSColor colorWithCalibratedWhite:0.400 alpha:1.000] forKey:@"selectedBorderUnemphasized"];
	}
	return self;
}


- (void)drawBackgroundInRect:(NSRect)dirtyRect {
	CGRect rect = self.bounds;
	
	[[NSColor whiteColor] setFill];
	[NSBezierPath fillRect:rect];
	
	CGRect separatorRect = rect;
	separatorRect.origin.y = separatorRect.size.height - 1.0f;
	separatorRect.size.height = 1.0f;
	
	[[self.colorList colorWithKey:@"border"] set];
	[NSBezierPath fillRect:separatorRect];
	
	NSTableCellView *cellView = nil;
	if (self.numberOfColumns > 0 && (cellView = [self viewAtColumn:0])) {
		cellView.backgroundStyle = NSBackgroundStyleLight;
	}
}


- (void)drawSelectionInRect:(NSRect)dirtyRect {
	CGRect rect = self.bounds;
	rect.size.height -= 1.0f;
	
	NSColor *topColor = nil;
	NSColor *bottomColor = nil;
	NSColor *bottomBorderColor = nil;
	
	if (self.emphasized) {
		topColor = [self.colorList colorWithKey:@"selectedTop"];
		bottomColor = [self.colorList colorWithKey:@"selectedBottom"];
		bottomBorderColor = [self.colorList colorWithKey:@"selectedBorder"];
	} else {
		topColor = [self.colorList colorWithKey:@"selectedTopUnemphasized"];
		bottomColor = [self.colorList colorWithKey:@"selectedBottomUnemphasized"];
		bottomBorderColor = [self.colorList colorWithKey:@"selectedBorderUnemphasized"];
	}
	
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

@end
