//
//  CDMAddTaskTextFieldCell.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMAddTaskTextFieldCell.h"
#import "NSImage+CDMAdditions.h"

// Inspired by http://stackoverflow.com/a/8626071/118631

@implementation CDMAddTaskTextFieldCell

- (NSRect)adjustedFrameToVerticallyCenterText:(NSRect)frame {
	NSInteger offset = floor((NSHeight(frame) - ([[self font] ascender] - [[self font] descender])) / 2);
	NSRect rect = NSInsetRect(frame, 0.0, offset);
	rect.origin.x += 10.0f;
	rect.origin.y -= 1.0f;
	rect.size.width -= 20.0f;
	return rect;
}


- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)editor delegate:(id)delegate event:(NSEvent *)event {
	[super editWithFrame:[self adjustedFrameToVerticallyCenterText:aRect] inView:controlView editor:editor delegate:delegate event:event];
}


- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)editor delegate:(id)delegate start:(NSInteger)start length:(NSInteger)length {
	
	[super selectWithFrame:[self adjustedFrameToVerticallyCenterText:aRect] inView:controlView editor:editor delegate:delegate start:start length:length];
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)view {
	NSImage *image = [NSImage imageNamed:@"textfield"];
	[image drawStretchableInRect:frame edgeInsets:NSEdgeInsetsMake(0.0, 8.0, 0.0, 8.0) operation:NSCompositeSourceOver fraction:1.0];
	
	[super drawInteriorWithFrame:[self adjustedFrameToVerticallyCenterText:frame] inView:view];
}

@end
