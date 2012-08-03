//
//  CDMAddTaskView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMAddTaskView.h"

@interface CDMAddTaskView ()
@property (nonatomic, strong) NSColorList *colorList;
@end

@implementation CDMAddTaskView

@synthesize textField = _textField;
@synthesize colorList = _colorList;

- (BOOL)isFlipped {
	return YES;
}


- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.colorList = [[NSColorList alloc] initWithName:NSStringFromClass([self class])];
	
	NSColorSpace *sRGB = [NSColorSpace sRGBColorSpace];
	
	[self.colorList setColor:[NSColor whiteColor] forKey:@"topInset"];
	
	CGFloat components[] = { 240.0 / 255.0, 240.0 / 255.0, 240.0 / 255.0, 1.0 };
	[self.colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"backgroundTop"];
	
	components[0] = 227.0 / 255.0;
	components[1] = 227.0 / 255.0;
	components[2] = 227.0 / 255.0;
	[self.colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"backgroundBottom"];

	components[0] = 233.0 / 255.0;
	components[1] = 233.0 / 255.0;
	components[2] = 233.0 / 255.0;
	[self.colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"bottomInset"];
	
	components[0] = 180.0 / 255.0;
	components[1] = 180.0 / 255.0;
	components[2] = 180.0 / 255.0;
	[self.colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"bottomBorder"];
}


- (void)drawRect:(NSRect)dirtyRect {
	CGSize size = self.bounds.size;
	
	[[self.colorList colorWithKey:@"topInset"] setFill];
	[NSBezierPath fillRect:CGRectMake(0.0f, 0.0f, size.width, 1.0)];
	
	CGRect rect = CGRectMake(0.0f, 1.0f, size.width, size.height - 3.0f);
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[self.colorList colorWithKey:@"backgroundTop"]
														 endingColor:[self.colorList colorWithKey:@"backgroundBottom"]];
	[gradient drawInRect:rect angle:90.0f];
	
	[[self.colorList colorWithKey:@"bottomInset"] setFill];
	[NSBezierPath fillRect:CGRectMake(0.0f, size.height - 2.0f, size.width, 1.0)];
	
	[[self.colorList colorWithKey:@"bottomBorder"] setFill];
	[NSBezierPath fillRect:CGRectMake(0.0f, size.height - 1.0f, size.width, 1.0)];
}

@end
