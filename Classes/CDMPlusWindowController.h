//
//  CDMPlusWindowController.h
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDMPlusWindowController : NSWindowController

@property (nonatomic, assign) NSWindow *parentWindow;
@property (nonatomic, weak) IBOutlet NSView *dialogView;

@property (nonatomic, weak) IBOutlet NSTextField *titleLabel;
@property (nonatomic, weak) IBOutlet NSTextField *messageLabel;

- (IBAction)upgrade:(id)sender;

@end
