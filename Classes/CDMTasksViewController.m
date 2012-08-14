//
//  CDMTasksViewController.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTasksViewController.h"
#import "CDMTaskTableRowView.h"

static NSString* const CDMTasksDragTypeRearrange = @"CDMTasksDragTypeRearrange";

@interface CDMTasksViewController ()

@end

@implementation CDMTasksViewController
@synthesize arrayController = _arrayController;
@synthesize tableView = _tableView;
@synthesize selectedList = _selectedList;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.arrayController.managedObjectContext = [CDKTask mainContext];
	self.arrayController.sortDescriptors = [CDKTask defaultSortDescriptors];
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObject:CDMTasksDragTypeRearrange]];
}

#pragma mark - Accessors

- (void)setSelectedList:(CDKList *)selectedList
{
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

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
    [pboard declareTypes:[NSArray arrayWithObject:CDMTasksDragTypeRearrange] owner:self];
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard setData:archivedData forType:CDMTasksDragTypeRearrange];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{
    return (operation == NSTableViewDropAbove) ? NSDragOperationMove : NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
    // Insert your code here to make the change in the data model
    NSLog(@"dropped index: %ld", row);
    return YES;
}
@end
