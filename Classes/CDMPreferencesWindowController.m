//
//  CDMPreferencesWindowController.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/13/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMPreferencesWindowController.h"
#import "MASShortcutView+UserDefaults.h"
#import "MASShortcut+UserDefaults.h"
#import <Carbon/Carbon.h>

@interface CDMPreferencesWindowController ()
- (void)_userChanged:(NSNotification *)notification;
@end

@implementation CDMPreferencesWindowController

@synthesize generalPreferenceView = _generalPreferenceView;
@synthesize accountPreferenceView = _accountPreferenceView;
@synthesize updatesPreferenceView = _updatesPreferenceView;
@synthesize usernameLabel = _usernameLabel;
@synthesize quickAddShortcutView = _quickAddShortcutView;


#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - NSWindowController

- (void)showWindow:(id)sender {
	if (![CDKUser currentUser]) {
		return;
	}
	[super showWindow:sender];
}


- (void)windowDidLoad {
	[super windowDidLoad];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userChanged:) name:kCDKCurrentUserChangedNotificationName object:nil];
	[self _userChanged:nil];

    self.quickAddShortcutView.associatedUserDefaultsKey = kCDMUserDefaultsQuickAddShortcutKey;
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


#pragma mark - Private

- (void)_userChanged:(NSNotification *)notification {
	self.usernameLabel.stringValue = [NSString stringWithFormat:@"You are signed in as %@.", [CDKUser currentUser].username];
}

@end
