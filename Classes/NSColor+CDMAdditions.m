//
//  NSColor+CDMAdditions.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/13/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "NSColor+CDMAdditions.h"

@implementation NSColor (CDMAdditions)

#pragma mark - Primary Colors

+ (NSColor *)cheddarOrangeColor {
	return [NSColor colorWithCalibratedRed:0.988 green:0.287 blue:0.031 alpha:1.0];
}


+ (NSColor *)cheddarSteelColor {
	return [NSColor colorWithCalibratedRed:0.526 green:0.541 blue:0.598 alpha:1.0];
}


+ (NSColor *)cheddarArchesColor {
	return [self colorWithPatternImage:[NSImage imageNamed:@"arches"]];
}


+ (NSColor *)cheddarTextColor {
	return [self colorWithCalibratedWhite:0.267f alpha:1.0f];
}


+ (NSColor *)cheddarLightTextColor {
    return [self colorWithCalibratedRed:0.200 green:0.200 blue:0.200 alpha:1];
}


+ (NSColor *)cheddarBlueColor {
    return [NSColor colorWithCalibratedRed:0.083 green:0.427 blue:0.641 alpha:1.0];
}


#pragma mark - Tag Filter Bar

+ (NSColor *)cheddarFilterBarBottomColor {
	return [NSColor colorWithCalibratedRed:0.071 green:0.570 blue:0.801 alpha:1.0];
}


+ (NSColor *)cheddarFilterBarTopColor {
	return [NSColor colorWithCalibratedRed:0.082 green:0.654 blue:0.887 alpha:1.0];
}


+ (NSColor *)cheddarFilterBarInactiveTopColor {
	return [NSColor colorWithCalibratedRed:0.710 green:0.705 blue:0.710 alpha:1.0];
}


+ (NSColor *)cheddarFilterBarInactiveBottomColor {
	return [NSColor colorWithCalibratedWhite:0.542 alpha:1.0];
}

+ (NSColor *)cheddarFilterBarInsetColor {
	return [NSColor colorWithCalibratedRed:0.370 green:0.687 blue:0.834 alpha:1.0];
}


+ (NSColor *)cheddarFilterBarInactiveInsetColor {
	return [NSColor colorWithCalibratedWhite:0.585 alpha:1.0];
}


+ (NSColor *)cheddarFilterBarBottomBorderColor {
	return [NSColor colorWithCalibratedRed:0.083 green:0.427 blue:0.641 alpha:1.0];
}


+ (NSColor *)cheddarFilterBarInactiveBottomBorderColor {
	return [NSColor colorWithCalibratedWhite:0.4 alpha:1.0];
}


#pragma mark - Add Task Bar

+ (NSColor *)cheddarAddTaskBarTopInsetColor {
	return [NSColor whiteColor];
}


+ (NSColor *)cheddarAddTaskBarTopColor {
	NSColorSpace *sRGB = [NSColorSpace sRGBColorSpace];
	CGFloat components[] = { 240.0 / 255.0, 240.0 / 255.0, 240.0 / 255.0, 1.0 };
	return [NSColor colorWithColorSpace:sRGB components:components count:4];
}


+ (NSColor *)cheddarAddTaskBarBottomColor {
	NSColorSpace *sRGB = [NSColorSpace sRGBColorSpace];
	CGFloat components[] = { 227.0 / 255.0, 227.0 / 255.0, 227.0 / 255.0, 1.0 };
	return [NSColor colorWithColorSpace:sRGB components:components count:4];
}


+ (NSColor *)cheddarAddTaskBarBottomInsetColor {
	NSColorSpace *sRGB = [NSColorSpace sRGBColorSpace];
	CGFloat components[] = { 233.0 / 255.0, 233.0 / 255.0, 233.0 / 255.0, 1.0 };
	return [NSColor colorWithColorSpace:sRGB components:components count:4];
}


+ (NSColor *)cheddarAddTaskBarBottomBorderColor {
	NSColorSpace *sRGB = [NSColorSpace sRGBColorSpace];
	CGFloat components[] = { 180.0 / 255.0, 180.0 / 255.0, 180.0 / 255.0, 1.0 };
	return [NSColor colorWithColorSpace:sRGB components:components count:4];
}


#pragma mark - Table

+ (NSColor *)cheddarCellSeparatorColor {
	return [NSColor colorWithCalibratedWhite:0.926 alpha:1.0];
}


+ (NSColor *)cheddarCellBackgroundColor {
	return [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.747 alpha:1.0];
}


+ (NSColor *)cheddarCellSelectedBackgroundColor {
	return [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.747 alpha:1.0];
}

@end
