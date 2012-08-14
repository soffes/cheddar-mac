//
//  CDMMainWindowController.h
//  Cheddar
//
//  Created by Sam Soffes on 6/15/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@class CDMListsViewController;
@class CDMTasksViewController;

@interface CDMMainWindowController : NSWindowController

@property (nonatomic, strong) IBOutlet CDMListsViewController *listsViewController;
@property (nonatomic, strong) IBOutlet CDMTasksViewController *tasksViewController;
@property (nonatomic, weak) IBOutlet NSView *splitViewLeft;
@property (nonatomic, weak) IBOutlet NSPanel *createListPanel;

- (IBAction)createList:(id)sender;

@end
