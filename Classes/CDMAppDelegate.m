//
//  CDMAppDelegate.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 6/14/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "CDMAppDelegate.h"
#import "CDMSignInWindowController.h"
#import "CDMMainWindowController.h"
#import "CDMPreferencesWindowController.h"
#import "CDMDefines.h"
#import "CDMListsViewController.h"
#import "CDMTasksViewController.h"

@interface CDMAppDelegate ()
- (void)_userChanged:(NSNotification *)notification;
@end

@implementation CDMAppDelegate

@synthesize signInWindowController = _signInWindowController;
@synthesize mainWindowController = _mainWindowController;
@synthesize viewMenu = _viewMenu;


- (CDMSignInWindowController *)signInWindowController {
	if (!_signInWindowController) {
		_signInWindowController = [[CDMSignInWindowController alloc] init];
	}
	return _signInWindowController;
}


#pragma mark - Class Methods

+ (CDMAppDelegate *)sharedAppDelegate {
	return (CDMAppDelegate *)[NSApp delegate];
}


#pragma mark - Actions

- (IBAction)openPreferences:(id)sender{
	[[CDMPreferencesWindowController sharedPrefsWindowController] showWindow:nil];
}


- (IBAction)showHelp:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://cheddarapp.com/support"]];
}


- (IBAction)showMainWindow:(id)sender {
	[_mainWindowController showWindow:sender];
}


- (IBAction)addList:(id)sender {
    [_mainWindowController.listsViewController addList:self];
}


- (IBAction)addTask:(id)sender {
    [_mainWindowController.tasksViewController focusTaskField:nil];
}


#pragma mark - Private

- (void)_userChanged:(NSNotification *)notification {
	if (![CDKUser currentUser]) {
		[self.signInWindowController showWindow:nil];
	}
}


#pragma mark - NSMenuDelegate

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
	if (![CDKUser currentUser]) {
		if ([menuItem.title isEqualToString:@"New List"] || [menuItem.title isEqualToString:@"New Task"] ||
			[menuItem.title isEqualToString:@"Preferences"] || [menuItem.title isEqualToString:@"Tasks"]) {
			return NO;
		}
	}
	return YES;
}


#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Optionally enable development mode
#ifdef CHEDDAR_API_DEVELOPMENT_MODE
	[CDKHTTPClient setDevelopmentModeEnabled:YES];
	[CDKPushController setDevelopmentModeEnabled:YES];
#endif

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults registerDefaults:[[NSDictionary alloc] initWithObjectsAndKeys:
									[NSNumber numberWithBool:YES], @"SUEnableAutomaticChecks",
									[NSNumber numberWithBool:YES], @"SUAllowsAutomaticUpdates",
									[NSNumber numberWithBool:NO], @"SUEnableSystemProfiling",
									nil]];

	[userDefaults synchronize];

	// Initialize Core Data
	[SSManagedObject mainContext];
	
	// Setup the OAuth credentials
	[[CDKHTTPClient sharedClient] setClientID:kCDMAPIClientID secret:kCDMAPIClientSecret];

	_mainWindowController = [[CDMMainWindowController alloc] init];
    self.viewMenu.delegate = _mainWindowController;
	[_mainWindowController showWindow:nil];

	if (![CDKUser currentUser]) {
		[self.signInWindowController showWindow:nil];
	}

	dispatch_async(dispatch_get_main_queue(), ^{
		// Initialize the connection to Pusher
		[CDKPushController sharedController];

		// Add observer for sign out
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userChanged:) name:kCDKCurrentUserChangedNotificationName object:nil];
	});
}


- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
	return [[SSManagedObject mainContext] undoManager];
}


- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    if (![SSManagedObject hasMainContext]) {
        return NSTerminateNow;
    }
	
    [[SSManagedObject mainContext] save:nil];
    return NSTerminateNow;
}

@end
