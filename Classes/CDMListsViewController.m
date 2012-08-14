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
#import <QuartzCore/QuartzCore.h>

static NSString* const kCDMListsDragTypeRearrange = @"CDMListsDragTypeRearrange";

@implementation CDMListsViewController {
    BOOL _awakenFromNib;
}
@synthesize arrayController = _arrayController;
@synthesize tableView = _tableView;
@synthesize tasksViewController = _tasksViewController;


#pragma mark - NSObject

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObjects:kCDMListsDragTypeRearrange, kCDMTasksDragTypeMove, nil]];
	
    if (_awakenFromNib) {
        return;
    }
		
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

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
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
	return 45.0f;
}


#pragma mark - NSTableViewDataSource

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    [pboard declareTypes:[NSArray arrayWithObject:kCDMListsDragTypeRearrange] owner:self];
	
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
    [pboard setData:archivedData forType:kCDMListsDragTypeRearrange];
	
    return YES;
}


- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation {
    NSPasteboard *pboard = [info draggingPasteboard];
    return ([pboard dataForType:kCDMTasksDragTypeMove] && operation == NSTableViewDropOn) || ([pboard dataForType:kCDMListsDragTypeRearrange] && operation == NSTableViewDropAbove);
}


- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation {
    NSPasteboard *pasteboard = [info draggingPasteboard];
    NSManagedObjectContext *context = [self.arrayController managedObjectContext];
    if (operation == NSTableViewDropAbove) {
        NSMutableArray *lists = [[self.arrayController arrangedObjects] mutableCopy];
        NSIndexSet *originalIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:[pasteboard dataForType:kCDMListsDragTypeRearrange]];
        NSUInteger originalListIndex = [originalIndexes firstIndex];
        NSUInteger destinationRow = (row > originalListIndex) ? row - 1 : row;
        CDKList *list = [self.arrayController.arrangedObjects objectAtIndex:originalListIndex];
        [lists removeObject:list];
        [lists insertObject:list atIndex:destinationRow];
        NSInteger i = 0;
        for (list in lists) {
            list.position = [NSNumber numberWithInteger:i++];
        }
        [context save:nil];
        [CDKList sortWithObjects:lists];
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:kCDMTableViewAnimationDuration];
        [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.tableView moveRowAtIndex:originalListIndex toIndex:destinationRow];
        [NSAnimationContext endGrouping];
    } else {
        NSURL *URI = [NSKeyedUnarchiver unarchiveObjectWithData:[pasteboard dataForType:kCDMTasksDragTypeMove]];
        NSPersistentStoreCoordinator *coordinator = [context persistentStoreCoordinator];
        NSManagedObjectID *objectID = [coordinator managedObjectIDForURIRepresentation:URI];
        CDKTask *task = (CDKTask*)[context existingObjectWithID:objectID error:nil];
        CDKList *list = [[self.arrayController arrangedObjects] objectAtIndex:row];
        [task setList:list];
    }
    return YES;
}
@end
