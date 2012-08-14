//
//  CDKTask+CDMAdditions.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDKTask+CDMAdditions.h"
#import "NSColor+CDMAdditions.h"

@implementation CDKTask (CDMAdditions)
- (NSAttributedString *)attributedDisplayText {
	if (!self.displayText) {
		if (!self.text) {
			return nil;
		}
		return [[NSAttributedString alloc] initWithString:self.text];
	}
    
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.displayText];
    NSRange range = NSMakeRange(0, [self.displayText length]);
    [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:kCDMRegularFontName size:15.f] range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[self isCompleted] ? [NSColor cheddarSteelColor] : [NSColor cheddarLightTextColor] range:range];
	[self addEntitiesToAttributedString:attributedString];
	return attributedString;
}

- (void)addEntitiesToAttributedString:(NSMutableAttributedString *)attributedString {
	// Add entities
	for (NSDictionary *entity in self.entities) {
		NSArray *indices = [entity objectForKey:@"display_indices"];
		NSRange range = NSMakeRange([[indices objectAtIndex:0] unsignedIntegerValue], 0);
		range.length = [[indices objectAtIndex:1] unsignedIntegerValue] - range.location;
		range = [attributedString.string composedRangeWithRange:range];
        
		// Skip malformed entities
		if (range.length > self.displayText.length) {
			continue;
		}
        
		NSString *type = [entity objectForKey:@"type"];
        
		// Italic
		if ([type isEqualToString:@"emphasis"]) {
			[attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:kCDMItalicFontName size:15.f] range:range];
		}
        
		// Bold
		else if ([type isEqualToString:@"double_emphasis"]) {
			[attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:kCDMBoldFontName size:15.f] range:range];
		}
        
		// Bold Italic
		else if ([type isEqualToString:@"triple_emphasis"]) {
			[attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:kCDMBoldItalicFontName size:15.f] range:range];
		}
        
		// Strikethrough
		else if ([type isEqualToString:@"strikethrough"]) {
			[attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle] range:range];
		}
        
		// Code
		else if ([type isEqualToString:@"code"]) {
			[attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Courier" size:15.f] range:range];
		}
	}
}

@end
