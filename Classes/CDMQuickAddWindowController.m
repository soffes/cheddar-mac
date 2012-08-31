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

@interface CDMQuickAddWindowController ()

@end

@implementation CDMQuickAddWindowController {
    NSArrayController *_arrayController;
    CDKList *_selectedList;
}
@synthesize listPopUpButton = _listPopUpButton;

#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"QuickAdd";
}

- (void)windowDidLoad
{
    [super windowDidLoad];
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
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"arrangedObjects"]) {
        NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Lists"];
        CDKList *selectedList = [[[[NSApp delegate] mainWindowController] listsViewController] selectedList];
        NSMenuItem *selectedItem = nil;
        for (CDKList *list in [_arrayController arrangedObjects]) {
            NSMenuItem *item = [menu addItemWithTitle:[list title] action:@selector(menuSelectedList:) keyEquivalent:@""];
            [item setTarget:self];
            [item setRepresentedObject:list];
            if (selectedList && [list isEqual:selectedList]) {
                selectedItem = item;
            }
        }
        [self.listPopUpButton setMenu:menu];
        [self.listPopUpButton selectItem:selectedItem];
    }
}

- (void)menuSelectedList:(NSMenuItem *)item
{
    _selectedList = [item representedObject];
}

@end
