//
//  CDMTaskTableRowView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTaskTableRowView.h"

#define kCDMTasksTableRowBackgroundColor [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.747 alpha:1.0]

@interface CDMTaskTableRowView ()
@property (nonatomic, strong) NSColorList *colorList;
@end

@implementation CDMTaskTableRowView

@synthesize colorList = _colorList;

- (id)initWithFrame:(NSRect)frameRect {
	if ((self = [super initWithFrame:frameRect])) {
		self.colorList = [[NSColorList alloc] initWithName:NSStringFromClass([self class])];
		
		NSColorSpace *sRGB = [NSColorSpace sRGBColorSpace];
		
		CGFloat components[] = { 240 / 255.0, 240 / 255.0, 240 / 255.0, 1.0 };
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
@end
