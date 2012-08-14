//
//  CDMTasksViewController.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTasksViewController.h"
#import "CDMTaskTableRowView.h"
#import <QuartzCore/QuartzCore.h>

static NSString* const kCDMTasksDragTypeRearrange = @"CDMTasksDragTypeRearrange";
NSString* const kCDMTasksDragTypeMove = @"CDMTasksDragTypeMove";

@implementation CDMTasksViewController {
    BOOL _awakenFromNib;
}
@synthesize arrayController = _arrayController;
@synthesize tableView = _tableView;
@synthesize selectedList = _selectedList;
@synthesize taskField = _taskField;

#pragma mark - NSObject

- (void)awakeFromNib {
    [super awakeFromNib];
    if (_awakenFromNib) { return; }
    self.arrayController.managedObjectContext = [CDKTask mainContext];
	self.arrayController.sortDescriptors = [CDKTask defaultSortDescriptors];
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObject:kCDMTasksDragTypeRearrange]];
    _awakenFromNib = YES;
}

#pragma mark - Actions

- (IBAction)addTask:(id)sender
{
    NSString *taskText = [self.taskField stringValue];
    [self.taskField setStringValue:@""];
    [[self.taskField window] makeFirstResponder:self.tableView];
    CDKTask *task = [[CDKTask alloc] init];
    task.text = taskText;
    task.displayText = taskText;
    task.list = self.selectedList;
    task.position = [NSNumber numberWithInteger:self.selectedList.highestPosition + 1];
    // [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:[self.tableView numberOfRows]] withAnimation:NSTableViewAnimationSlideDown];
    [task createWithSuccess:nil failure:^(AFJSONRequestOperation *remoteOperation, NSError *error) {
        NSLog(@"Error creating task: %@, %@", error, [error userInfo]);
    }];
}

#pragma mark - Accessors

- (void)setSelectedList:(CDKList *)selectedList {
	if (_selectedList != selectedList) {
		_selectedList = selectedList;
	}
	[[CDKHTTPClient sharedClient] getTasksWithList:_selectedList success:^(AFJSONRequestOperation *operation, id responseObject) {
		[self.arrayController fetch:nil];
	} failure:nil];
	self.arrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"list = %@ AND archivedAt = nil", _selectedList];
	[self.arrayController fetch:nil];
}

#pragma mark - NSTableViewDelegate

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
	return [[CDMTaskTableRowView alloc] initWithFrame:CGRectZero];
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	return 38.0f;
}


#pragma mark - NSTableViewDataSource

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard declareTypes:[NSArray arrayWithObject:kCDMTasksDragTypeRearrange] owner:self];
    NSData *rowData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    CDKTask *task = [self.arrayController.arrangedObjects objectAtIndex:[rowIndexes firstIndex]];
    NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:[[task objectID] URIRepresentation]];
    [pboard setData:rowData forType:kCDMTasksDragTypeRearrange];
    [pboard setData:objectData forType:kCDMTasksDragTypeMove];
    return YES;
}


- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation {
    return (operation == NSTableViewDropAbove) ? NSDragOperationMove : NSDragOperationNone;
}


- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation {
    NSMutableArray *tasks = [self.arrayController.arrangedObjects mutableCopy];
    NSPasteboard *pasteboard = [info draggingPasteboard];
    NSIndexSet *originalIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:[pasteboard dataForType:kCDMTasksDragTypeRearrange]];
    NSUInteger originalListIndex = [originalIndexes firstIndex];
    NSUInteger destinationRow = (row > originalListIndex) ? row - 1 : row;
	CDKTask *task = [self.arrayController.arrangedObjects objectAtIndex:originalListIndex];
	[tasks removeObject:task];
	[tasks insertObject:task atIndex:destinationRow];
	NSInteger i = 0;
	for (task in tasks) {
		task.position = [NSNumber numberWithInteger:i++];
	}
	[self.arrayController.managedObjectContext save:nil];
	[CDKTask sortWithObjects:tasks];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:kCDMTableViewAnimationDuration];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.tableView moveRowAtIndex:originalListIndex toIndex:destinationRow];
    [NSAnimationContext endGrouping];
    return YES;
}

@end
