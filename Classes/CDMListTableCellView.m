//
//  CDMListTableCellView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMListTableCellView.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMListTableCellView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.textField.font = [NSFont fontWithName:kCDMRegularFontName size:15.0];
	self.textField.textColor = [NSColor cheddarLightTextColor];
}


- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {
    [super setBackgroundStyle:backgroundStyle];
    if ([[[self.textField window] firstResponder] isKindOfClass:[NSTextView class]]
        && [[self.textField window] fieldEditor:NO forObject:nil]!=nil
        && [self.textField isEqualTo:(id)[(NSTextView *)[[self.textField window] firstResponder] delegate]]) {
        self.textField.textColor = [NSColor cheddarLightTextColor];
    } else if (backgroundStyle == NSBackgroundStyleDark) {
        [self.textField setTextColor:[NSColor whiteColor]];
    } else if(backgroundStyle == NSBackgroundStyleLight) {
        self.textField.textColor = [NSColor cheddarLightTextColor];
    }
}

@end
