//
//  CDMListsWindowController.h
//  Cheddar
//
//  Created by Sam Soffes on 6/15/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDMListsWindowController : NSWindowController <NSTableViewDelegate>

@property (weak) IBOutlet NSArrayController *listsArrayController;
@property (weak) IBOutlet NSTableView *listsTableView;
@property (weak) IBOutlet NSArrayController *tasksArrayController;
@property (weak) IBOutlet NSTableView *tasksTableView;

@end
