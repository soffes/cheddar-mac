//
//  CDMPreferencesRowView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/13/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMPreferencesRowView.h"

@implementation CDMPreferencesRowView

- (void)drawRect:(NSRect)dirtyRect {
	CGRect rect = self.bounds;
	[[NSColor colorWithCalibratedRed:0.945 green:0.945 blue:0.945 alpha:1] setFill];
	[NSBezierPath fillRect:rect];

	rect.origin.y = rect.size.height - 1.0f;
	rect.size.height = 1.0f;
	[[NSColor colorWithCalibratedRed:0.859 green:0.859 blue:0.859 alpha:1] setFill];
	[NSBezierPath fillRect:rect];

	rect.origin.y--;
	[[NSColor whiteColor] setFill];
	[NSBezierPath fillRect:rect];
}

@end
