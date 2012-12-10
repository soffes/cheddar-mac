//
//  CDMLoadingView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 12/9/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMLoadingView.h"
#import "NSView+CDMAdditions.h"
#import "NSColor+CDMAdditions.h"

static CGFloat const interiorPadding = 20.0f;
static CGFloat const indicatorSize = 16.0f;
static CGFloat const indicatorRightMargin = 6.0f;

@implementation CDMLoadingView

#pragma mark - NSView

- (id)initWithFrame:(NSRect)frameRect {
	if ((self = [super initWithFrame:frameRect])) {
		// View defaults
		self.autoresizingMask = NSViewAutoresizingFlexibleWidth | NSViewAutoresizingFlexibleHeight;
		self.backgroundColor = [NSColor cheddarArchesColor];

		// Setup label
		_textLabel = [[NSTextField alloc] init];
		_textLabel.bordered = NO;
		_textLabel.editable = NO;
		_textLabel.stringValue = @"Loading...";
		_textLabel.font = [NSFont fontWithName:kCDMRegularFontName size:14.0f];
		_textLabel.textColor = [NSColor darkGrayColor];
		[self addSubview:_textLabel];

		// Setup the indicator
		_activityIndicatorView = [[NSProgressIndicator alloc] init];
		_activityIndicatorView.style = NSProgressIndicatorSpinningStyle;
		[_activityIndicatorView startAnimation:nil];
		[self addSubview:_activityIndicatorView];
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	CGRect frame = self.frame;

	// Calculate sizes
	CGSize maxSize = CGSizeMake(frame.size.width - (interiorPadding * 2.0f) - indicatorSize - indicatorRightMargin, indicatorSize);
	CGSize textSize = [_textLabel.stringValue boundingRectWithSize:maxSize options:0 attributes:@{NSFontAttributeName: _textLabel.font}].size;
	textSize.width += 6.0f;

	// Calculate position
	CGFloat totalWidth = textSize.width + indicatorSize + indicatorRightMargin;
	NSInteger y = (NSInteger)((frame.size.height / 2.0f) - (indicatorSize / 2.0f));

	// Position the indicator
	_activityIndicatorView.frame = CGRectMake((NSInteger)((frame.size.width - totalWidth) / 2.0f), y, indicatorSize, indicatorSize);

	// Calculate text position
	_textLabel.frame = CGRectMake(_activityIndicatorView.frame.origin.x + indicatorSize + indicatorRightMargin, y, textSize.width, textSize.height);
}

@end
