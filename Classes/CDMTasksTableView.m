//
//  CDMTasksTableView.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-28.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTasksTableView.h"
#import "CDMTaskTableRowView.h"

@implementation CDMTasksTableView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.selectedTaskRow = -1;
    }
    return self;
}


- (void)setSelectedTaskRow:(NSInteger)selectedTaskRow {
    if (_selectedTaskRow != selectedTaskRow) {
        if (_selectedTaskRow != -1 && _selectedTaskRow < [self numberOfRows]) {
            CDMTaskTableRowView *oldRow = (CDMTaskTableRowView *)[self rowViewAtRow:_selectedTaskRow makeIfNecessary:NO];
            oldRow.taskSelected = NO;
        }
        _selectedTaskRow = selectedTaskRow;
        if (_selectedTaskRow != -1 && _selectedTaskRow < [self numberOfRows]) {
            CDMTaskTableRowView *newRow = (CDMTaskTableRowView*)[self rowViewAtRow:_selectedTaskRow makeIfNecessary:NO];
            newRow.taskSelected = YES;
        }
    }
}


- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    NSPoint localPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:localPoint];
    if (row == -1) {
        self.selectedTaskRow = -1;
    }
}


- (void)keyDown:(NSEvent *)theEvent {
    NSString *characters = [theEvent characters];
    if ([characters isEqualToString:@"j"] || [characters isEqualToString:@"n"]) {
        [self moveDown:nil];
    } else if ([characters isEqualToString:@"k"] || [characters isEqualToString:@"p"]) {
        [self moveUp:nil];
    } else {
        [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
    }
}


- (void)moveDown:(id)sender {
    NSInteger row = self.selectedTaskRow + 1;
    self.selectedTaskRow = (row >= [self numberOfRows]) ? 0 : row;
}


- (void)moveUp:(id)sender {
    NSInteger row = self.selectedTaskRow - 1;
    self.selectedTaskRow = (row < 0) ? [self numberOfRows] - 1 : row;
}


- (void)cancelOperation:(id)sender {
    self.selectedTaskRow = -1;
}

@end
