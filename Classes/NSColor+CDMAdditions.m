//
//  NSColor+CDMAdditions.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/13/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "NSColor+CDMAdditions.h"

@implementation NSColor (CDMAdditions)

+ (NSColor *)cheddarOrangeColor {
	return [NSColor colorWithCalibratedRed:0.988 green:0.287 blue:0.031 alpha:1.000];
}


+ (NSColor *)cheddarSteelColor {
	return [NSColor colorWithCalibratedRed:0.526 green:0.541 blue:0.598 alpha:1.000];
}


+ (NSColor *)cheddarArchesColor {
	return [self colorWithPatternImage:[NSImage imageNamed:@"arches"]];
}

@end
