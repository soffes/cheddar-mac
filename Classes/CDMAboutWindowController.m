//
//  CDMAboutWindowController.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/13/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMAboutWindowController.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMAboutWindowController

@synthesize subheaderLabel = _subheaderLabel;
@synthesize copyrightLabel = _copyrightLabel;

#pragma mark - NSObject

- (void)awakeFromNib {
	[super awakeFromNib];

	self.subheaderLabel.font = [NSFont fontWithName:kCDMRegularFontName size:15.0f];
	self.subheaderLabel.textColor = [NSColor cheddarSteelColor];

	self.copyrightLabel.font = [NSFont fontWithName:kCDMRegularFontName size:12.0f];
	self.copyrightLabel.textColor = [[NSColor cheddarSteelColor] colorWithAlphaComponent:0.5f];
}


#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"About";
}

@end
