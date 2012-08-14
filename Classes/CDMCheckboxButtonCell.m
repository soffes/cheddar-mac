//
//  CDMCheckboxButtonCell.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/12/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMCheckboxButtonCell.h"
#import "CDMCheckboxButton.h"

@implementation CDMCheckboxButtonCell

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView {
	CDMCheckboxButton *button = (CDMCheckboxButton *)controlView;

	NSColor *cheddarSteelColor = [NSColor colorWithCalibratedRed:0.53 green:0.55 blue:0.59 alpha:1.0];

	CGFloat scaleFactor = [[controlView window] backingScaleFactor];
	NSColor *cheddarCheckboxInnerShadow = [NSColor colorWithCalibratedRed:0.75 green:0.75 blue:0.75 alpha:0.4];

	NSBezierPath *roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(0.5, 0.5, 18, 18) xRadius: 5 yRadius: 5];
	[[NSColor whiteColor] setFill];
	[roundedRectanglePath fill];

	[cheddarSteelColor setStroke];
	[roundedRectanglePath setLineWidth:scaleFactor];
	[roundedRectanglePath stroke];

	NSBezierPath *roundedRectangle2Path = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(1.5, 1.5, 16, 16) xRadius: 4 yRadius: 4];
	[cheddarCheckboxInnerShadow setStroke];
	[roundedRectangle2Path setLineWidth:scaleFactor];
	[roundedRectangle2Path stroke];

	if (button.state == NSOnState) {
		NSImage *check = [NSImage imageNamed:@"check"];
		[check drawInRect:CGRectMake(3.0f, 4.0f, 14.0f, 11.0f) fromRect:CGRectMake(0.0f, 0.0f, 14.0f, 11.0f) operation:NSCompositeSourceOver fraction:1.0f];
	}
}

@end
