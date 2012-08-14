//
//  CDKTask+CDMAdditions.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/13/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDKTask+CDMAdditions.h"
#import "NSColor+CDMAdditions.h"

@implementation CDKTask (CDMAdditions)

- (NSColor *)textColor {
	NSColor *color = nil;
	if (self.completed) {
		color = [NSColor cheddarSteelColor];
	} else {
		color = [NSColor colorWithCalibratedRed:0.200 green:0.200 blue:0.200 alpha:1];
	}
	return color;
}

@end
