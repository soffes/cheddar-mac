//
//  CDMListsViewController.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMListsViewController.h"
#import "CDMListTableRowView.h"
#import "CDMTasksViewController.h"

static NSString* const CDMListsDragTypeRearrange = @"CDMListsDragTypeRearrange";

@interface CDMListsViewController ()

@end

@implementation CDMListsViewController {
    BOOL _awakenFromNib;
}
@synthesize arrayController = _arrayController;
@synthesize tableView = _tableView;
@synthesize tasksViewController = _tasksViewController;

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (_awakenFromNib) { return; }
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObject:CDMListsDragTypeRearrange]];
    self.arrayController.managedObjectContext = [CDKList mainContext];
	self.arrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"archivedAt = nil && user = %@", [CDKUser currentUser]];
	self.arrayController.sortDescriptors = [CDKList defaultSortDescriptors];
    [[CDKHTTPClient sharedClient] getListsWithSuccess:^(AFJSONRequestOperation *operation, id responseObject) {
		NSLog(@"Got lists");
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		NSLog(@"Failed to get lists: %@", error);
	}];
    _awakenFromNib = YES;
}

#pragma mark - NSTableViewDelegate

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selectedRow = [self.tableView selectedRow];
    if (selectedRow != -1) {
        CDKList *list = [[self.arrayController arrangedObjects] objectAtIndex:selectedRow];
        [self.tasksViewController setSelectedList:list];
    }
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
	return [[CDMListTableRowView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	return 45.f;
}

#pragma mark - NSTableViewDataSource

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
    [pboard declareTypes:[NSArray arrayWithObject:CDMListsDragTypeRearrange] owner:self];
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard setData:archivedData forType:CDMListsDragTypeRearrange];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{
    return (operation == NSTableViewDropAbove) ? NSDragOperationMove : NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
    NSMutableArray *lists = [self.arrayController.arrangedObjects mutableCopy];
    NSPasteboard *pasteboard = [info draggingPasteboard];
    NSIndexSet *originalIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:[pasteboard dataForType:CDMListsDragTypeRearrange]];
    NSUInteger originalListIndex = [originalIndexes firstIndex];
    NSUInteger destinationRow = (row > originalListIndex) ? row - 1 : row;
	CDKList *list = [self.arrayController.arrangedObjects objectAtIndex:originalListIndex];
	[lists removeObject:list];
	[lists insertObject:list atIndex:destinationRow];
	NSInteger i = 0;
	for (list in lists) {
		list.position = [NSNumber numberWithInteger:i++];
	}
	[self.arrayController.managedObjectContext save:nil];
	[CDKList sortWithObjects:lists];
    [self.tableView moveRowAtIndex:originalListIndex toIndex:destinationRow];
    return YES;
}
@end
