//
//  CDMPreferencesWindowController.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/13/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMPreferencesWindowController.h"
#import "MASShortcutView+UserDefaults.h"

@implementation CDMPreferencesWindowController

@synthesize generalPreferenceView = _generalPreferenceView;
@synthesize accountPreferenceView = _accountPreferenceView;
@synthesize updatesPreferenceView = _updatesPreferenceView;
@synthesize usernameLabel = _usernameLabel;
@synthesize quickAddShortcutView = _quickAddShortcutView;


#pragma mark - NSWindowController

- (void)showWindow:(id)sender {
	if (![CDKUser currentUser]) {
		return;
	}
	[super showWindow:sender];
}


- (void)windowDidLoad {
	[super windowDidLoad];
	self.usernameLabel.stringValue = [NSString stringWithFormat:@"You are signed in as %@.", [CDKUser currentUser].username];
    self.quickAddShortcutView.associatedUserDefaultsKey = @"quickAddShortcut";
}


#pragma mark - DBPrefsWindowController

- (void)setupToolbar {
    [self addView:self.generalPreferenceView label:@"General" image:[NSImage imageNamed:@"NSPreferencesGeneral"]];
    [self addView:self.accountPreferenceView label:@"Account" image:[NSImage imageNamed:@"NSUser"]];
    [self addView:self.updatesPreferenceView label:@"Updates" image:[NSImage imageNamed:@"preferences-updates"]];

    [self setCrossFade:YES];
    [self setShiftSlowsAnimation:YES];
}


#pragma mark - Actions

- (IBAction)signOut:(id)sender {
	[CDKUser setCurrentUser:nil];
	[self close];
}


- (IBAction)manageAccount:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://cheddarapp.com/account"]];
}

@end
