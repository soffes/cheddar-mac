//
//  CDMTasksPlaceholderView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 12/9/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTasksPlaceholderView.h"
#import "NSColor+CDMAdditions.h"
#import "NSView+CDMAdditions.h"

@implementation CDMTasksPlaceholderView

#pragma mark - NSObject

- (void)awakeFromNib {
	[super awakeFromNib];

	self.autoresizingMask = NSViewAutoresizingFlexibleWidth | NSViewAutoresizingFlexibleHeight;

	self.backgroundColor = [NSColor cheddarArchesColor];
	self.addLabel.frameCenterRotation = 2.0f;
	self.titleLabel.font = [NSFont fontWithName:kCDMRegularFontName size:15.f];
}


#pragma mark - NSView

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	[self setNeedsLayout:YES];
}


- (void)resizeSubviewsWithOldSize:(NSSize)oldSize {
	[super resizeSubviewsWithOldSize:oldSize];
	
	CGSize size = self.bounds.size;
	CGSize iconSize = self.iconImageView.bounds.size;
	self.iconImageView.frame = CGRectMake(roundf((size.width - iconSize.width) / 2.0f), roundf((size.height + iconSize.height) / 2.0f), iconSize.width, iconSize.height);
	self.titleLabel.frame = CGRectMake(roundf((size.width - 280.0f) / 2.0f), _iconImageView.frame.origin.y - iconSize.height - 20.0f, 280.0f, 40.0f);
}

@end
