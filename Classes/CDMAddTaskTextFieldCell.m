//
//  CDMAddTaskTextFieldCell.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMAddTaskTextFieldCell.h"
#import "NSImage+CDMAdditions.h"

@implementation CDMAddTaskTextFieldCell {
	BOOL _selected;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.font = [NSFont fontWithName:kCDIRegularFontName size:16.0];
	self.textColor = [NSColor colorWithCalibratedRed:0.200 green:0.200 blue:0.200 alpha:1];
	self.placeholderString = @"What do you have to do?";
}


// From http://stackoverflow.com/a/8626071/118631
- (NSRect)adjustedFrameToVerticallyCenterText:(NSRect)frame {
	NSInteger offset = floor((NSHeight(frame) - ([[self font] ascender] - [[self font] descender])) / 2);
	NSRect rect = NSInsetRect(frame, 0.0, offset);
	rect.origin.x += 10.0f;
	rect.origin.y += 1.0f;
	rect.size.width -= 20.0f;
	return rect;
}


- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)editor delegate:(id)delegate event:(NSEvent *)event {
	_selected = YES;
	[super editWithFrame:[self adjustedFrameToVerticallyCenterText:aRect] inView:controlView editor:editor delegate:delegate event:event];
}


- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)editor delegate:(id)delegate start:(NSInteger)start length:(NSInteger)length {
	_selected = YES;
	[super selectWithFrame:[self adjustedFrameToVerticallyCenterText:aRect] inView:controlView editor:editor delegate:delegate start:start length:length];
}


- (void)endEditing:(NSText *)textObj {
	_selected = NO;
	[super endEditing:textObj];
}


- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)view {
	// Background
	NSImage *image = _selected ? [NSImage imageNamed:@"textfield-focused"] : [NSImage imageNamed:@"textfield"];
	[image drawStretchableImageInRect:frame leftCapWidth:8.0f];
	
	// Placeholder color
	if (self.stringValue.length == 0) {
		[[NSColor colorWithCalibratedRed:0.624 green:0.635 blue:0.675 alpha:1] set];
	} else {
		[self.textColor set];
	}
	
	// Draw text
	[super drawInteriorWithFrame:[self adjustedFrameToVerticallyCenterText:frame] inView:view];
}

@end
