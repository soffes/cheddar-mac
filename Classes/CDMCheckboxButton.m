//
//  CDMCheckboxButton.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/12/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMCheckboxButton.h"
#import "CDMCheckboxButtonCell.h"

@implementation CDMCheckboxButton

- (void)awakeFromNib {
	[super awakeFromNib];

	self.cell = [[CDMCheckboxButtonCell alloc] initTextCell:nil];
}


- (void)drawRect:(NSRect)dirtyRect {
	[self.cell drawBezelWithFrame:self.bounds inView:self];
}

@end
