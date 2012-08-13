//
//  CDMTextFieldCell.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTextFieldCell.h"

static CGFloat const kCDMTextFieldCellXInset = 10.0f;

@implementation CDMTextFieldCell
- (void)awakeFromNib {
	[super awakeFromNib];
	self.font = [NSFont fontWithName:kCDMRegularFontName size:16.0];
	self.textColor = [NSColor colorWithCalibratedRed:0.200 green:0.200 blue:0.200 alpha:1];
    [self setDrawsBackground:NO];
    [self setBordered:NO];
    [self setBezeled:NO];
}

// From http://stackoverflow.com/a/8626071/118631
- (NSRect)adjustedFrameToVerticallyCenterText:(NSRect)frame {
	NSInteger offset = floor((NSHeight(frame) - ([[self font] ascender] - [[self font] descender])) / 2);
	return NSInsetRect(frame, kCDMTextFieldCellXInset, offset);
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)editor delegate:(id)delegate event:(NSEvent *)event {
	[super editWithFrame:[self adjustedFrameToVerticallyCenterText:aRect] inView:controlView editor:editor delegate:delegate event:event];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)editor delegate:(id)delegate start:(NSInteger)start length:(NSInteger)length {
	[super selectWithFrame:[self adjustedFrameToVerticallyCenterText:aRect] inView:controlView editor:editor delegate:delegate start:start length:length];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [super drawInteriorWithFrame:[self adjustedFrameToVerticallyCenterText:cellFrame] inView:controlView];
}
@end
