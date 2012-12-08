//
//  CDMBoolToTaskTextColorValueTransformer.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMBoolToTaskTextColorValueTransformer.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMBoolToTaskTextColorValueTransformer

+ (Class)transformedValueClass {
	return [NSColor class];
}


+ (BOOL)allowsReverseTransformation {
	return NO;
}


- (id)transformedValue:(id)value {
    return [value boolValue] ? [NSColor cheddarSteelColor] : [NSColor cheddarLightTextColor];
}

@end
