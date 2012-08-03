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
		
		components[0] = 240 / 255.0;
		components[1] = 240 / 255.0;
		components[2] = 240 / 255.0;
		[self.colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"border"];
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
}


- (void)drawSelectionInRect:(NSRect)dirtyRect {
	CGRect rect = self.bounds;
	rect.size.height -= 1.0f;
	
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[self.colorList colorWithKey:@"selectedTop"]
														 endingColor:[self.colorList colorWithKey:@"selectedBottom"]];
	[gradient drawInRect:rect angle:90.0f];
	
	CGRect separatorRect = self.bounds;
	separatorRect.origin.y = separatorRect.size.height - 1.0f;
	separatorRect.size.height = 1.0f;
	
	[[self.colorList colorWithKey:@"selectedBorder"] setFill];
	[NSBezierPath fillRect:separatorRect];
}

@end
