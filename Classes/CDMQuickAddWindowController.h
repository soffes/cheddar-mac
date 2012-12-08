//
//  CDMQuickAddWindowController.h
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-27.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDMQuickAddWindowController : NSWindowController

@property (nonatomic, weak) IBOutlet NSPopUpButton *listPopUpButton;
@property (nonatomic, weak) IBOutlet NSTextField *addTaskField;

- (IBAction)addTask:(id)sender;
- (void)activate;

@end
