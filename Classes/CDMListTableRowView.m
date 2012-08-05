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
		
		NSColorSpace *sRGB = [NSColorSpace sRGBColorSpace];
		
		CGFloat components[] = { 0.0, 182.0 / 255.0, 232.0 / 255.0, 1.0 };
		[self.colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"selectedTop"];
		
		components[1] = 163.0 / 255.0;
		components[2] = 214.0 / 255.0;
		[self.colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"selectedBottom"];
		
		components[1] = 137.0 / 255.0;
		components[2] = 192.0 / 255.0;
		[self.colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"selectedBorder"];
		
		components[0] = 240.0 / 255.0;
		components[1] = 240.0 / 255.0;
		components[2] = 240.0 / 255.0;
		[self.colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"border"];
		
		components[0] = 138.0 / 255.0;
		components[1] = 143.0 / 255.0;
		components[2] = 155.0 / 255.0;
		[self.colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"selectedTopUnemphasized"];
		
		components[0] = 104.0 / 255.0;
		components[1] = 109.0 / 255.0;
		components[2] = 120.0 / 255.0;
		[self.colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"selectedBottomUnemphasized"];
		
		components[0] = 84.0 / 255.0;
		components[1] = 88.0 / 255.0;
		components[2] = 96.0 / 255.0;
		[self.colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"selectedBorderUnemphasized"];
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
