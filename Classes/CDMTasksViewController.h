//
//  CDMTasksViewController.h
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

extern NSString* const kCDMTasksDragTypeMove;

@interface CDMTasksViewController : NSViewController <NSTextFieldDelegate>

@property (nonatomic, weak) IBOutlet NSArrayController *arrayController;
@property (nonatomic, weak) IBOutlet NSTableView *tableView;
@property (nonatomic, weak) IBOutlet NSTextField *taskField;
@property (nonatomic, weak) IBOutlet NSView *tagFilterBar;
@property (nonatomic, weak) IBOutlet NSTextField *tagNameField;
@property (nonatomic, weak) IBOutlet NSView *addTaskView;

@property (nonatomic, strong) CDKList *selectedList;
- (IBAction)addTask:(id)sender;
- (IBAction)focusTaskField:(id)sender;
- (void)addFilterForTag:(CDKTag*)tag;
@end
