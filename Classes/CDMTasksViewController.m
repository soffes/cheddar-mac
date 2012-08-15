//
//  CDMTasksViewController.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTasksViewController.h"
#import "CDMTaskTableRowView.h"
#import "CDMTaskTableCellView.h"
#import <QuartzCore/QuartzCore.h>
#import "CDKTask+CDMAdditions.h"
#import "CDMColorView.h"

static NSString* const kCDMTasksDragTypeRearrange = @"CDMTasksDragTypeRearrange";
NSString* const kCDMTasksDragTypeMove = @"CDMTasksDragTypeMove";
static NSString* const kCDMTaskCellIdentifier = @"TaskCell";
static CGFloat const kCDMTasksViewControllerTagBarAnimationDuration = 0.3f;

@interface CDMTasksViewController ()
- (void)setTagBarVisible:(BOOL)visible;
@end

@implementation CDMTasksViewController {
    BOOL _awakenFromNib;
    CDMColorView *_overlayView;
}
@synthesize arrayController = _arrayController;
@synthesize tableView = _tableView;
@synthesize selectedList = _selectedList;
@synthesize taskField = _taskField;
@synthesize tagFilterBar = _tagFilterBar;
@synthesize tagNameField = _tagNameField;
@synthesize addTaskView = _addTaskView;

#pragma mark - NSObject

- (void)awakeFromNib {
    [super awakeFromNib];

	if (_awakenFromNib) {
		return;
	}

    self.arrayController.managedObjectContext = [CDKTask mainContext];
	self.arrayController.sortDescriptors = [CDKTask defaultSortDescriptors];
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObject:kCDMTasksDragTypeRearrange]];

	_awakenFromNib = YES;
}


#pragma mark - Actions

- (IBAction)addTask:(id)sender {
    NSString *taskText = [self.taskField stringValue];
    [self.taskField setStringValue:@""];
    if ([taskText length]) {
        CDKTask *task = [[CDKTask alloc] init];
        task.text = taskText;
        task.displayText = taskText;
        task.list = self.selectedList;
        task.position = [NSNumber numberWithInteger:self.selectedList.highestPosition + 1];
        [task createWithSuccess:^{
            NSUInteger index = [[self.arrayController arrangedObjects] indexOfObject:task];
            if (index != NSNotFound) {
                [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
            }
        } failure:^(AFJSONRequestOperation *remoteOperation, NSError *error) {
            NSLog(@"Error creating task: %@, %@", error, [error userInfo]);
        }];
    }
}


- (IBAction)focusTaskField:(id)sender {
    [[self.taskField window] makeFirstResponder:self.taskField];
}

#pragma mark - Tags

- (void)filterToTagWithName:(NSString*)tagName {
    CDKTag *tag = [CDKTag existingTagWithName:tagName];
    if (tag) {
        [self.tagNameField setStringValue:[@"#" stringByAppendingString:tagName]];
        [self.arrayController setFilterPredicate:[NSPredicate predicateWithFormat:@"%@ IN tags", tag]];
        [self setTagBarVisible:YES];
    }
}

- (void)setTagBarVisible:(BOOL)visible {
    NSView *parentView = [self.addTaskView superview];
    NSScrollView *scrollView = [self.tableView enclosingScrollView];
    if (visible && ![self.tagFilterBar superview]) {
        NSRect beforeTagFrame = [self.tagFilterBar frame];
        beforeTagFrame.size = [self.addTaskView frame].size;
        beforeTagFrame.origin.y = NSMaxY([scrollView frame]) - beforeTagFrame.size.height;
        [self.tagFilterBar setFrame:beforeTagFrame];
        _overlayView = [[CDMColorView alloc] initWithFrame:[self.addTaskView frame]];
        [_overlayView setColor:[NSColor colorWithDeviceWhite:0.f alpha:0.8f]];
        [_overlayView setAlphaValue:0.f];
        [_overlayView setAutoresizingMask:[self.addTaskView autoresizingMask]];
        [parentView addSubview:self.tagFilterBar positioned:NSWindowAbove relativeTo:self.addTaskView];
        [parentView addSubview:_overlayView positioned:NSWindowBelow relativeTo:self.tagFilterBar];
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setCompletionHandler:^{
            [self.addTaskView setHidden:YES];
        }];
        [[NSAnimationContext currentContext] setDuration:kCDMTasksViewControllerTagBarAnimationDuration];
        [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[_overlayView animator] setAlphaValue:1.f];
        [[self.tagFilterBar animator] setFrame:[self.addTaskView frame]];
        [NSAnimationContext endGrouping];
    } else if (!visible && [self.tagFilterBar superview]) {
        NSRect newTagFrame = [self.tagFilterBar frame];
        newTagFrame.origin.y = NSMaxY([scrollView frame]) - newTagFrame.size.height;
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setCompletionHandler:^{
            [self.tagFilterBar removeFromSuperview];
            [_overlayView removeFromSuperview];
            _overlayView = nil;
        }];
        [[NSAnimationContext currentContext] setDuration:kCDMTasksViewControllerTagBarAnimationDuration];
        [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.addTaskView setHidden:NO];
        [[_overlayView animator] setAlphaValue:0.f];
        [[self.tagFilterBar animator] setFrame:newTagFrame];
        [NSAnimationContext endGrouping];
    }
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
    self.arrayController.filterPredicate = nil;
    [self setTagBarVisible:NO];
	[self.arrayController fetch:nil];
}


#pragma mark - NSTableViewDelegate

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
	return [[CDMTaskTableRowView alloc] initWithFrame:CGRectZero];
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	return 38.0f;
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    CDMTaskTableCellView *cellView = [tableView makeViewWithIdentifier:kCDMTaskCellIdentifier owner:self];
    CDKTask *task = [[self.arrayController arrangedObjects] objectAtIndex:row];
    [cellView.textField setAttributedStringValue:[task attributedDisplayText]];
    return cellView;
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

	[NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        CDKTask *task = [self.arrayController.arrangedObjects objectAtIndex:originalListIndex];
        [tasks removeObject:task];
        [tasks insertObject:task atIndex:destinationRow];
        NSInteger i = 0;
        for (task in tasks) {
            task.position = [NSNumber numberWithInteger:i++];
        }
        
        [self.arrayController.managedObjectContext save:nil];
        
        [CDKTask sortWithObjects:tasks];
    }];
    [[NSAnimationContext currentContext] setDuration:kCDMTableViewAnimationDuration];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.tableView moveRowAtIndex:originalListIndex toIndex:destinationRow];
    [NSAnimationContext endGrouping];

	return YES;
}

@end
