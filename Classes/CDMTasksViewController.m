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
#import "CDMTagFilterBar.h"
#import "CDMTaskTextField.h"
#import "CDMTasksPlaceholderView.h"
#import "CDMLoadingView.h"

static NSString *const kCDMTasksDragTypeRearrange = @"CDMTasksDragTypeRearrange";
NSString *const kCDMTasksDragTypeMove = @"CDMTasksDragTypeMove";
static NSString *const kCDMTaskCellIdentifier = @"TaskCell";
static NSString *const kCDMNoTasksNibName = @"NoTasks";
static NSString *const kCDMLoadingTasksNibName = @"LoadingTasks";

static CGFloat const kCDMTasksViewControllerTagBarAnimationDuration = 0.3f;
static NSString *const kCDMTasksViewControllerImageTagX = @"tag-x";
static NSString *const kCDMTasksViewControllerImageTagXUnfocused = @"tag-x-unfocused";

@interface CDMTasksViewController ()
- (void)_setTagBarVisible:(BOOL)visible;
- (void)_clearTagFilter;
- (void)_resetTagXButtonImage;
- (void)_setNoTasksViewVisible:(BOOL)visible;
- (void)_resetArrayController;
@end

@implementation CDMTasksViewController {
    BOOL _awakenFromNib;
    CDMColorView *_overlayView;
    NSMutableArray *_filterTags;
}

#pragma mark - NSObject

- (void)awakeFromNib {
    [super awakeFromNib];

	if (_awakenFromNib) {
		return;
	}

    _filterTags = [NSMutableArray array];
    [self.tableView registerForDraggedTypes:[NSArray arrayWithObject:kCDMTasksDragTypeRearrange]];
    [self addObserver:self forKeyPath:@"arrayController.arrangedObjects" options:0 context:NULL];
    [self.tableView bind:@"content" toObject:self withKeyPath:@"arrayController.arrangedObjects" options:nil];
    
    NSWindow *window = [self.tableView window];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(_resetTagXButtonImage) name:NSWindowDidBecomeKeyNotification object:window];
    [nc addObserver:self selector:@selector(_resetTagXButtonImage) name:NSWindowDidResignKeyNotification object:window];

	_awakenFromNib = YES;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_tableView unbind:@"content"];
    [self removeObserver:self forKeyPath:@"arrayController.arrangedObjects"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"arrayController.arrangedObjects"]) {
        if ([self.loadingTasksView superview])
            [self _setLoadingTasksViewVisible:![[self.arrayController arrangedObjects] count]];
        [self _setNoTasksViewVisible:![[self.arrayController arrangedObjects] count]];
    }
}

#pragma mark - Actions

- (IBAction)addTask:(id)sender {
    NSString *taskText = [self.taskField stringValue];
    [self.taskField setStringValue:@""];
    [self addTaskWithName:taskText inList:self.selectedList];
}

- (void)addTaskWithName:(NSString *)name inList:(CDKList *)list
{
    if ([name length]) {
        CDKTask *task = [[CDKTask alloc] init];
        task.text = name;
        task.displayText = name;
        task.list = list;
        task.position = [NSNumber numberWithInteger:list.highestPosition + 1];
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

- (void)_resetTagXButtonImage
{
    BOOL active = [[self.tableView window] isKeyWindow] && [NSApp isActive];
    NSImage *image = [NSImage imageNamed:active ? kCDMTasksViewControllerImageTagX : kCDMTasksViewControllerImageTagXUnfocused];
    [self.tagXImageView setImage:image];
}

#pragma mark - Tags

- (void)addFilterForTag:(CDKTag*)tag
{
    if (![_filterTags containsObject:tag]) {
        [_filterTags addObject:tag];
        [self _resetTagFilter];
    }
}

- (void)_resetArrayController
{
    self.arrayController = [NSArrayController new];
    self.arrayController.managedObjectContext = [CDKTask mainContext];
    self.arrayController.sortDescriptors = [CDKTask defaultSortDescriptors];
    self.arrayController.entityName = @"Task";
    self.arrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"list = %@ AND archivedAt = nil", _selectedList];
    self.arrayController.clearsFilterPredicateOnInsertion = YES;
    self.arrayController.automaticallyRearrangesObjects = YES;
    self.arrayController.automaticallyPreparesContent = YES;
    [self _clearTagFilter];
}

- (void)_resetTagFilter
{
    if ([_filterTags count]) {
        NSString *text = [[NSString stringWithFormat:@"#%@", [[_filterTags valueForKey:@"name"] componentsJoinedByString:@" #"]] lowercaseString];
        [self.tagNameField setStringValue:text];
        NSMutableArray *subpredicates = [NSMutableArray arrayWithCapacity:[_filterTags count]];
        for (CDKTag *tag in _filterTags) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ in tags", tag];
            [subpredicates addObject:predicate];
        }
        [self.arrayController setFilterPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:subpredicates]];
        [self _setTagBarVisible:YES];
    }
}

- (void)_setTagBarVisible:(BOOL)visible {
    NSView *parentView = [self.addTaskView superview];
    NSScrollView *scrollView = [self.tableView enclosingScrollView];
    if (visible && ![self.tagFilterBar superview]) {
        NSRect beforeTagFrame = [self.tagFilterBar frame];
        beforeTagFrame.size = [self.addTaskView frame].size;
        beforeTagFrame.origin.y = NSMaxY([scrollView frame]) - beforeTagFrame.size.height;
        [self.tagFilterBar setFrame:beforeTagFrame];
        _overlayView = [[CDMColorView alloc] initWithFrame:[self.addTaskView frame]];
        [_overlayView setBackgroundColor:[NSColor colorWithDeviceWhite:0.f alpha:0.8f]];
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


- (void)_clearTagFilter {
    self.arrayController.filterPredicate = nil;
    [_filterTags removeAllObjects];
    [self _setTagBarVisible:NO];
}


- (void)_setNoTasksViewVisible:(BOOL)visible {
	// Show
    if (visible && ![self.noTasksView superview]) {
        if (!self.noTasksView) {
            self.noTasksView = [[CDMTasksPlaceholderView alloc] init];
        }

		self.noTasksView.frame = self.tableView.bounds;
		[self.tableView addSubview:self.noTasksView];
    }

	// Hide
	else if (!visible && [self.noTasksView superview]) {
        [self.noTasksView removeFromSuperview];
    }
}


- (void)_setLoadingTasksViewVisible:(BOOL)visible {
    if (visible && ![self.loadingTasksView superview]) {
        if (!self.loadingTasksView) {
            self.loadingTasksView = [[CDMLoadingView alloc] init];
        }

		self.loadingTasksView.frame = self.tableView.bounds;
		[self.tableView addSubview:self.loadingTasksView];
    } else if (!visible && [self.loadingTasksView superview]) {
        [self.loadingTasksView removeFromSuperview];
    }
}


#pragma mark - CDMTagFilterBarDelegate

- (void)tagFilterBarClicked:(CDMTagFilterBar*)bar {
    [self _clearTagFilter];
}


#pragma mark - CDMTaskTextFieldDelegate

- (NSString *)editingTextForTextField:(NSTextField*)textField {
    NSInteger row = [self.tableView rowForView:textField];
    if (row != -1) {
        CDKTask *task = [[self.arrayController arrangedObjects] objectAtIndex:row];
        return task.text;
    }
    return nil;
}


- (void)controlTextDidEndEditing:(NSNotification *)obj {
    NSTextField *textField = [obj object];
    NSInteger row = [self.tableView rowForView:textField];
    if (row != -1) {
        CDKTask *task = [[self.arrayController arrangedObjects] objectAtIndex:row];
        task.text = [textField stringValue];
        [task save];
        [task update];
        [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    }
}


- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command {
    if (command == @selector(cancelOperation:)) {
        [[control window] makeFirstResponder:self.tableView];
        return YES;
    }
    return NO;
}


#pragma mark - Accessors

- (void)setSelectedList:(CDKList *)selectedList {
	if (_selectedList != selectedList) {
		_selectedList = selectedList;
        [self _resetArrayController];
        [self _setLoadingTasksViewVisible:![[self.arrayController arrangedObjects] count]];
        [self _setNoTasksViewVisible:NO];
        [[CDKHTTPClient sharedClient] getTasksWithList:_selectedList success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.arrayController fetch:nil];
                [self _setLoadingTasksViewVisible:NO];
                [self _setNoTasksViewVisible:![[self.arrayController arrangedObjects] count]];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _setLoadingTasksViewVisible:NO];
            });
        }];
	}
}


#pragma mark - NSTableViewDelegate

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
	CDMTaskTableRowView *rowView = [[CDMTaskTableRowView alloc] initWithFrame:CGRectZero];
    rowView.rowIndex = row;
    rowView.taskSelected = NO;
    return rowView;
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

// Stub implementations to avoid assertion failure before the bindings have been made
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return 0;
}


- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    return nil;
}


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


#pragma mark - Menu Items

- (IBAction)editTask:(id)sender {
    NSInteger row = [self.tableView clickedRow];
    if (row != -1) {
        NSTableRowView *rowView = [self.tableView rowViewAtRow:row makeIfNecessary:NO];
        NSTableCellView *cellView = [rowView viewAtColumn:0];
        CDMTaskTextField *textField = (CDMTaskTextField *)cellView.textField;
        [textField beginEditing];
    }
}


- (IBAction)archiveTask:(id)sender {
    NSInteger row = [self.tableView clickedRow];
    if (row != -1) {
        CDKTask *task = [[self.arrayController arrangedObjects] objectAtIndex:row];
        task.archivedAt = [NSDate date];
        [task save];
        [task update];
        [self.tableView reloadData];
    }
}


- (IBAction)deleteTask:(id)sender {
    NSInteger row = [self.tableView clickedRow];
    if (row != -1) {
        CDKTask *task = [[self.arrayController arrangedObjects] objectAtIndex:row];
        [task delete];
        [self.tableView reloadData];
    }
}

@end
