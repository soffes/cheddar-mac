//
//  CDMPlaceholderView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 12/9/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMPlaceholderView.h"
#import "NSColor+CDMAdditions.h"
#import "NSView+CDMAdditions.h"

@implementation CDMPlaceholderView

#pragma mark - NSView

- (id)initWithFrame:(NSRect)frameRect {
	if ((self = [super initWithFrame:frameRect])) {
		self.autoresizingMask = NSViewAutoresizingFlexibleWidth | NSViewAutoresizingFlexibleHeight;

		self.backgroundColor = [NSColor cheddarArchesColor];

		_iconImageView = [[NSImageView alloc] init];
		_iconImageView.autoresizingMask = NSViewAutoresizingFlexibleLeftMargin | NSViewAutoresizingFlexibleRightMargin | NSViewAutoresizingFlexibleBottomMargin;
		[self addSubview:_iconImageView];

		_titleLabel = [[NSTextField alloc] init];
		_titleLabel.backgroundColor = [NSColor clearColor];
		_titleLabel.bordered = NO;
		_titleLabel.editable = NO;
		_titleLabel.autoresizingMask = NSViewAutoresizingFlexibleLeftMargin | NSViewAutoresizingFlexibleRightMargin | NSViewAutoresizingFlexibleBottomMargin;
		_titleLabel.alignment = NSCenterTextAlignment;
		_titleLabel.textColor = [NSColor colorWithCalibratedRed:0.702f green:0.694f blue:0.686f alpha:1.0f];
		_titleLabel.font = [NSFont fontWithName:kCDMRegularFontName size:15.0f];
		[self addSubview:_titleLabel];
	}
	return self;
}


- (BOOL)isFlipped {
	return YES;
}


- (void)resizeSubviewsWithOldSize:(NSSize)oldSize {
	[super resizeSubviewsWithOldSize:oldSize];

	CGSize size = self.bounds.size;
	CGSize iconSize = _iconImageView.image.size;
	iconSize.width = roundf(iconSize.width);
	iconSize.height = roundf(iconSize.height);

	_iconImageView.frame = CGRectMake(roundf((size.width - iconSize.width) / 2.0f), roundf((size.height - iconSize.height) / 2.0f) - 30.0f, iconSize.width, iconSize.height);
	_titleLabel.frame = CGRectMake(20.0f, _iconImageView.frame.origin.y + iconSize.height + 18.0f, size.width - 40.0f, 60.0f);
}

@end
