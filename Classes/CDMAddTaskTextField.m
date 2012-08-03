//
//  CDMAddTaskTextField.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMAddTaskTextField.h"
#import "NSImage+CDMAdditions.h"

@implementation CDMAddTaskTextField {
	BOOL _editing;
}


- (void)awakeFromNib {
	[super awakeFromNib];
	[self setDrawsBackground:NO];
}


- (BOOL)becomeFirstResponder {
	_editing = [super becomeFirstResponder];
	[self setNeedsDisplay];
	return _editing;
}


- (BOOL)resignFirstResponder {
	_editing = NO;
	[self setNeedsDisplay];
	return [super resignFirstResponder];
}


- (void)drawRect:(NSRect)rect {
	[super drawRect:rect];
	
//	[super drawRect:rect];
	[self lockFocus];
	
	NSImage *image = _editing ? [NSImage imageNamed:@"textfield-focused"] : [NSImage imageNamed:@"textfield"];
	[image drawStretchableInRect:self.bounds edgeInsets:NSEdgeInsetsMake(0.0, 8.0, 0.0, 8.0) operation:NSCompositeSourceOver fraction:1.0];
		
	[self unlockFocus];
}

@end
