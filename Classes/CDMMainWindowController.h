//
//  CDMMainWindowController.h
//  Cheddar
//
//  Created by Sam Soffes on 6/15/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@class CDMListsViewController;
@class CDMTasksViewController;

@interface CDMMainWindowController : NSWindowController <NSMenuDelegate>

@property (nonatomic, strong) IBOutlet CDMListsViewController *listsViewController;
@property (nonatomic, strong) IBOutlet CDMTasksViewController *tasksViewController;
@property (nonatomic, weak) IBOutlet NSView *splitViewLeft;
@property (nonatomic, weak) IBOutlet NSSplitView *splitView;
@property (nonatomic, weak) IBOutlet NSTextField *taskTextField;
@property (nonatomic, weak) NSMenu *listMenu;
- (IBAction)toggleSidebar:(id)sender;
@end
