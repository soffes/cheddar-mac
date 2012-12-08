//
//  CDMTasksViewController.h
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

extern NSString* const kCDMTasksDragTypeMove;

@interface CDMTasksViewController : NSViewController <NSTextFieldDelegate>

@property (nonatomic, strong) NSArrayController *arrayController;
@property (nonatomic, strong) CDKList *selectedList;

@property (nonatomic, weak) IBOutlet NSTableView *tableView;
@property (nonatomic, weak) IBOutlet NSTextField *taskField;
@property (nonatomic, weak) IBOutlet NSView *tagFilterBar;
@property (nonatomic, weak) IBOutlet NSTextField *tagNameField;
@property (nonatomic, weak) IBOutlet NSView *addTaskView;
@property (nonatomic, weak) IBOutlet NSImageView *tagXImageView;
@property (nonatomic, strong) IBOutlet NSView *noTasksView;
@property (nonatomic, strong) IBOutlet NSView *loadingTasksView;

- (void)addFilterForTag:(CDKTag*)tag;
- (void)addTaskWithName:(NSString *)name inList:(CDKList *)list;

- (IBAction)addTask:(id)sender;
- (IBAction)focusTaskField:(id)sender;

// Menu items
- (IBAction)editTask:(id)sender;
- (IBAction)archiveTask:(id)sender;
- (IBAction)deleteTask:(id)sender;

@end
