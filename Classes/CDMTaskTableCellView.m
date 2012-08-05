//
//  CDMTaskTableCellView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTaskTableCellView.h"

@implementation CDMTaskTableCellView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.textField.font = [NSFont fontWithName:kCDIRegularFontName size:15.0];
	self.textField.textColor = [NSColor colorWithCalibratedRed:0.200 green:0.200 blue:0.200 alpha:1];
}

@end
