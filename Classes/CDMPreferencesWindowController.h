//
//  CDMPreferencesWindowController.h
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/13/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "DBPrefsWindowController.h"

@class MASShortcutView;
@interface CDMPreferencesWindowController : DBPrefsWindowController

@property (weak, nonatomic) IBOutlet NSView *generalPreferenceView;
@property (weak, nonatomic) IBOutlet NSView *accountPreferenceView;

@property (weak, nonatomic) IBOutlet NSTextField *usernameLabel;
@property (weak, nonatomic) IBOutlet MASShortcutView *quickAddShortcutView;

- (IBAction)signOut:(id)sender;
- (IBAction)manageAccount:(id)sender;

@end
