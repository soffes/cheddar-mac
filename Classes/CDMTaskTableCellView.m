//
//  CDMTaskTableCellView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTaskTableCellView.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMTaskTableCellView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.textField.font = [NSFont fontWithName:kCDMRegularFontName size:15.0];
	self.textField.textColor = [NSColor colorWithCalibratedRed:0.200 green:0.200 blue:0.200 alpha:1];
}


- (void)setObjectValue:(id)objectValue {
	[super setObjectValue:objectValue];

	CDKTask *task = (CDKTask *)objectValue;
	if (task.completed) {
		self.textField.textColor = [NSColor cheddarSteelColor];
	} else {
		self.textField.textColor = [NSColor colorWithCalibratedRed:0.200 green:0.200 blue:0.200 alpha:1];
	}
}

@end
