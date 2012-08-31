//
//  CDMQuickAddWindowController.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-27.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMQuickAddWindowController.h"
#import "CDMAppDelegate.h"
#import "CDMMainWindowController.h"
#import "CDMListsViewController.h"
#import "CDMTasksViewController.h"

@interface CDMQuickAddWindowController ()
- (CDMListsViewController *)_listsViewController;
- (CDMTasksViewController *)_tasksViewController;
@end

@implementation CDMQuickAddWindowController {
    NSArrayController *_arrayController;
    CDKList *_selectedList;
    BOOL _closeWhenFinished;
}
@synthesize listPopUpButton = _listPopUpButton;
@synthesize addTaskField = _addTaskField;

#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"QuickAdd";
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[self window] setLevel:NSFloatingWindowLevel];
    CDMListsViewController *listsViewController = [self _listsViewController];
    [listsViewController addObserver:self forKeyPath:@"selectedList" options:0 context:NULL];
    _arrayController = [[NSArrayController alloc] init];
    _arrayController.managedObjectContext = [CDKList mainContext];
    _arrayController.entityName = @"List";
	_arrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"archivedAt = nil && user = %@", [CDKUser currentUser]];
	_arrayController.sortDescriptors = [CDKList defaultSortDescriptors];
    [_arrayController fetch:nil];
    [_arrayController addObserver:self forKeyPath:@"arrangedObjects" options:0 context:NULL];
    [[CDKHTTPClient sharedClient] getListsWithSuccess:^(AFJSONRequestOperation *operation, id responseObject) {
        [_arrayController fetch:nil];
    } failure:nil];
}

- (void)dealloc
{
    [_arrayController removeObserver:self forKeyPath:@"arrangedObjects"];
    [[self _listsViewController] removeObserver:self forKeyPath:@"selectedList"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"arrangedObjects"]) {
        NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Lists"];
        CDKList *selectedList = [[self _listsViewController] selectedList];
        NSMenuItem *selectedItem = nil;
        for (CDKList *list in [_arrayController arrangedObjects]) {
            NSMenuItem *item = [menu addItemWithTitle:[list title] action:@selector(menuSelectedList:) keyEquivalent:@""];
            [item setTarget:self];
            [item setRepresentedObject:list];
            if (selectedList && [list isEqual:selectedList]) {
                selectedItem = item;
                _selectedList = list;
            }
        }
        [self.listPopUpButton setMenu:menu];
        [self.listPopUpButton selectItem:selectedItem];
    } else if ([keyPath isEqualToString:@"selectedList"]) {
        CDKList *selectedList = [[self _listsViewController] selectedList];
        for (NSMenuItem *item in [self.listPopUpButton itemArray]) {
            if ([[item representedObject] isEqual:selectedList]) {
                [self.listPopUpButton selectItem:item];
                break;
            }
        }
    }
}

- (void)menuSelectedList:(NSMenuItem *)item {
    _selectedList = [item representedObject];
}

- (IBAction)addTask:(id)sender {
    NSString *taskText = [self.addTaskField stringValue];
    [self.addTaskField setStringValue:@""];
    [[self _tasksViewController] addTaskWithName:taskText inList:_selectedList];
    [[self window] close];
    if (_closeWhenFinished) {
        [NSApp hide:nil];
    }
}

- (void)activate
{
    if (![NSApp isActive]) {
        for (NSWindow *window in [NSApp windows]) {
            _closeWhenFinished = YES;
            [window orderOut:nil];
        }
        [NSApp activateIgnoringOtherApps:YES];
    }
    [self showWindow:nil];
    [[self window] makeFirstResponder:self.addTaskField];
}

- (CDMListsViewController *)_listsViewController
{
    return [[[NSApp delegate] mainWindowController] listsViewController];
}

- (CDMTasksViewController *)_tasksViewController
{
    return [[[NSApp delegate] mainWindowController] tasksViewController];
}
@end
