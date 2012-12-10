//
//  CDMTasksPlaceholderView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 12/9/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTasksPlaceholderView.h"

@implementation CDMTasksPlaceholderView

#pragma mark - NSView

- (id)initWithFrame:(NSRect)frameRect {
	if ((self = [super initWithFrame:frameRect])) {
		NSImageView *arrowImageView = [[NSImageView alloc] initWithFrame:CGRectMake(13.0f, 4.0f, 34.0f, 40.0f)];
		arrowImageView.image = [NSImage imageNamed:@"add-task-arrow"];
		[self addSubview:arrowImageView];

		NSTextField *arrowLabel = [[NSTextField alloc] initWithFrame:CGRectMake(42.0f, 26.0f, 85.0f, 22.0f)];
		arrowLabel.backgroundColor = [NSColor clearColor];
		arrowLabel.bordered = NO;
		arrowLabel.editable = NO;
		arrowLabel.font = [NSFont fontWithName:@"Noteworthy" size:13.0f];
		arrowLabel.textColor = [NSColor colorWithCalibratedWhite:0.294f alpha:0.45f];
		arrowLabel.frameCenterRotation = -2.0f;
		arrowLabel.stringValue = @"Add Task";
		[self addSubview:arrowLabel];

		self.iconImageView.image = [NSImage imageNamed:@"task-icon"];
		self.titleLabel.stringValue = @"You don't have any tasks in this list.";
	}
	return self;
}

@end
