//
//  CDMAddTaskView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMAddTaskView.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMAddTaskView

#pragma mark - NSView

- (BOOL)isFlipped {
	return YES;
}


- (void)drawRect:(NSRect)dirtyRect {
	CGSize size = self.bounds.size;
	
	[[NSColor cheddarAddTaskBarTopInsetColor] setFill];
	[NSBezierPath fillRect:CGRectMake(0.0f, 0.0f, size.width, 1.0)];
	
	CGRect rect = CGRectMake(0.0f, 1.0f, size.width, size.height - 3.0f);
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor cheddarAddTaskBarTopColor]
														 endingColor:[NSColor cheddarAddTaskBarBottomColor]];
	[gradient drawInRect:rect angle:90.0f];
	
	[[NSColor cheddarAddTaskBarBottomInsetColor] setFill];
	[NSBezierPath fillRect:CGRectMake(0.0f, size.height - 2.0f, size.width, 1.0)];
	
	[[NSColor cheddarAddTaskBarBottomBorderColor] setFill];
	[NSBezierPath fillRect:CGRectMake(0.0f, size.height - 1.0f, size.width, 1.0)];
}

@end
