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
	self.textField.font = [NSFont fontWithName:kCDMRegularFontName size:15.0];
	self.textField.textColor = [NSColor colorWithCalibratedRed:0.333 green:0.333 blue:0.333 alpha:1];;
}


- (void)drawRect:(NSRect)dirtyRect {
    if (self.backgroundStyle == NSBackgroundStyleDark) {
        [self.textField setTextColor:[NSColor whiteColor]];
    } else if(self.backgroundStyle == NSBackgroundStyleLight) {
        self.textField.textColor = [NSColor colorWithCalibratedRed:0.333 green:0.333 blue:0.333 alpha:1];
    }
}

@end
