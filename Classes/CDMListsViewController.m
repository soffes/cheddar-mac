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
#import "CDMWhiteOverlayView.h"
#import <QuartzCore/QuartzCore.h>

static NSString* const kCDMListsDragTypeRearrange = @"CDMListsDragTypeRearrange";
static CGFloat const kCDMTasksViewControllerAddListAnimationDuration = 0.15f;


@implementation CDMListsViewController {
    BOOL _awakenFromNib;
    CDMWhiteOverlayView *_overlayView;
}
@synthesize arrayController = _arrayController;
@synthesize tableView = _tableView;
@synthesize tasksViewController = _tasksViewController;
@synthesize addListView = _addListView;
@synthesize addListField = _addListField;

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

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:kCDKCurrentUserChangedNotificationName object:nil];

    [self reload:nil];
    _awakenFromNib = YES;
}


#pragma mark - Actions

- (IBAction)reload:(id)sender {
	[[CDKHTTPClient sharedClient] getListsWithSuccess:^(AFJSONRequestOperation *operation, id responseObject) {
		NSLog(@"Got lists");
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		NSLog(@"Failed to get lists: %@", error);
	}];

	[[CDKHTTPClient sharedClient] updateCurrentUserWithSuccess:nil failure:nil];
}


- (IBAction)addList:(id)sender {
    if ([self.addListView superview]) {
        [self closeAddList:nil];
        return;
    }
    NSScrollView *scrollView = [self.tableView enclosingScrollView];
    NSRect beforeAddFrame = [self.addListView frame];
    beforeAddFrame.origin.y = NSMaxY([scrollView frame]);
    beforeAddFrame.size.width = [scrollView frame].size.width;
    [self.addListView setFrame:beforeAddFrame];
    [self.addListField setStringValue:@""];
    NSView *parentView = [scrollView superview] ;
    [parentView addSubview:self.addListView positioned:NSWindowBelow relativeTo:[[parentView subviews] objectAtIndex:0]];
    _overlayView = [[CDMWhiteOverlayView alloc] initWithFrame:[scrollView frame]];
    [_overlayView setAlphaValue:0.f];
    [_overlayView setAutoresizingMask:[scrollView autoresizingMask]];
    [parentView addSubview:_overlayView positioned:NSWindowAbove relativeTo:scrollView];
    NSRect newScrollFrame = [scrollView frame];
    newScrollFrame.size.height -= [self.addListView frame].size.height;
    NSRect newAddFrame = beforeAddFrame;
    newAddFrame.origin.y = NSMaxY(newScrollFrame);
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:kCDMTasksViewControllerAddListAnimationDuration];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [[self.addListField window] makeFirstResponder:self.addListField];
    }];
    [[scrollView animator] setFrame:newScrollFrame];
    [[self.addListView animator] setFrame:newAddFrame];
    [[_overlayView animator] setFrame:newScrollFrame];
    [[_overlayView animator] setAlphaValue:1.f];
    [NSAnimationContext endGrouping];
}

- (IBAction)closeAddList:(id)sender {
    if (![self.addListView superview]) { return; }
    NSScrollView *scrollView = [self.tableView enclosingScrollView];
    NSRect newScrollFrame = [scrollView frame];
    newScrollFrame.size.height += [self.addListView frame].size.height;
    [[scrollView animator] setFrame:newScrollFrame];
    NSRect newAddFrame = [self.addListView frame];
    newAddFrame.origin.y = NSMaxY(newScrollFrame);
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:kCDMTasksViewControllerAddListAnimationDuration];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [self.addListView removeFromSuperview];
        [_overlayView removeFromSuperview];
        _overlayView = nil;
    }];
    [[scrollView animator] setFrame:newScrollFrame];
    [[self.addListView animator] setFrame:newAddFrame];
    [[_overlayView animator] setFrame:newScrollFrame];
    [[_overlayView animator] setAlphaValue:0.f];
    [NSAnimationContext endGrouping];
}

- (IBAction)createList:(id)sender {
    NSString *listName = [self.addListField stringValue];
    [self.addListField setStringValue:@""];
    [[self.tableView window] makeFirstResponder:self.tableView];
    if ([listName length]) {
        CDKList *list = [[CDKList alloc] init];
        list.title = listName;
        list.position = [NSNumber numberWithInteger:INT32_MAX];
        list.user = [CDKUser currentUser];
        [list createWithSuccess:^{
            NSUInteger index = [[self.arrayController arrangedObjects] indexOfObject:list];
            if (index != NSNotFound) {
                [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
                [self tableViewSelectionDidChange:nil];
            }
            [self.tasksViewController focusTaskField:nil];
        } failure:^(AFJSONRequestOperation *remoteOperation, NSError *error) {
            NSLog(@"Error creating list: %@, %@", error, [error userInfo]);
        }];
    }
    [self closeAddList:nil];
}


#pragma mark - NSControlTextEditingDelegate

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command {
    if (command == @selector(cancelOperation:)) {
        [self closeAddList:nil];
        return YES;
    }
    return NO;
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
    id sender = [aNotification object];
    NSInteger row = [self.tableView rowForView:sender];
    if (row != -1) {
        CDKList *list = [[self.arrayController arrangedObjects] objectAtIndex:row];
        [list save];
        [list update];
    }
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
        NSUInteger selectedRow = [aTableView selectedRow];
        NSUInteger destinationRow = (row > originalListIndex) ? row - 1 : row;
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:kCDMTableViewAnimationDuration];
        [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[NSAnimationContext currentContext] setCompletionHandler:^{
            CDKList *list = [self.arrayController.arrangedObjects objectAtIndex:originalListIndex];
            [lists removeObject:list];
            [lists insertObject:list atIndex:destinationRow];
            
            NSInteger i = 0;
            for (list in lists) {
                list.position = [NSNumber numberWithInteger:i++];
            }
            [context save:nil];
            
            [CDKList sortWithObjects:lists];
            if (selectedRow == originalListIndex) {
                
                [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:destinationRow] byExtendingSelection:NO];
                [self tableViewSelectionDidChange:nil];
            }
        }];
        [self.tableView moveRowAtIndex:originalListIndex toIndex:destinationRow];
        [NSAnimationContext endGrouping];
    } else {
        NSURL *URI = [NSKeyedUnarchiver unarchiveObjectWithData:[pasteboard dataForType:kCDMTasksDragTypeMove]];
        NSPersistentStoreCoordinator *coordinator = [context persistentStoreCoordinator];
        NSManagedObjectID *objectID = [coordinator managedObjectIDForURIRepresentation:URI];

		CDKTask *task = (CDKTask*)[context existingObjectWithID:objectID error:nil];
        CDKList *list = [[self.arrayController arrangedObjects] objectAtIndex:row];
        [task moveToList:list];
    }
    return YES;
}

@end
