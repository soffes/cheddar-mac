//
//  CDMTasksViewController.h
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDMTasksViewController : NSViewController

@property (nonatomic, weak) IBOutlet NSArrayController *arrayController;
@property (nonatomic, weak) IBOutlet NSTableView *tableView;

@property (nonatomic, strong) CDKList *selectedList;

@end
