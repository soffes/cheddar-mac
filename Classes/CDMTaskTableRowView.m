//
//  CDMTaskTableRowView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTaskTableRowView.h"
#import "CDMTasksTableView.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMTaskTableRowView

- (void)drawBackgroundInRect:(NSRect)dirtyRect {
	CGRect rect = self.bounds;
	
	[self.taskSelected ? [NSColor cheddarCellSelectedBackgroundColor] : [NSColor whiteColor] setFill];
	[NSBezierPath fillRect:rect];
	
	CGRect separatorRect = rect;
	separatorRect.origin.y = separatorRect.size.height - 1.0f;
	separatorRect.size.height = 1.0f;
	
	[[NSColor cheddarCellSeparatorColor] set];
	[NSBezierPath fillRect:separatorRect];
}


- (void)setTaskSelected:(BOOL)taskSelected {
    if (_taskSelected != taskSelected) {
        _taskSelected = taskSelected;
        [self setNeedsDisplay:YES];
    }
}


- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    CDMTasksTableView *tableView = (CDMTasksTableView *)[self superview];
    tableView.selectedTaskRow = self.rowIndex;
}

@end
