//
//  CDMListsPlaceholderView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 12/9/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMListsPlaceholderView.h"

@implementation CDMListsPlaceholderView

#pragma mark - NSView

- (id)initWithFrame:(NSRect)frameRect {
	if ((self = [super initWithFrame:frameRect])) {
		self.iconImageView.image = [NSImage imageNamed:@"list-icon"];
		self.titleLabel.stringValue = @"You don't have any lists.";
	}
	return self;
}

@end
