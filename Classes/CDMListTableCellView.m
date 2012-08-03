//
//  CDMListTableCellView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMListTableCellView.h"

@implementation CDMListTableCellView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.textField.font = [NSFont fontWithName:kCDIRegularFontName size:15.0];
}

@end
