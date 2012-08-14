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

@implementation CDMAppDelegate

@synthesize signInWindowController = _signInWindowController;
@synthesize mainWindowController = _mainWindowController;


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

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Optionally enable development mode
#ifdef CHEDDAR_API_DEVELOPMENT_MODE
	[CDKHTTPClient setDevelopmentModeEnabled:YES];
	[CDKPushController setDevelopmentModeEnabled:YES];
#endif

	// Initialize Core Data
	[SSManagedObject mainContext];
	
	// Setup the OAuth credentials
	[[CDKHTTPClient sharedClient] setClientID:kCDMAPIClientID secret:kCDMAPIClientSecret];

	_mainWindowController = [[CDMMainWindowController alloc] init];
	[_mainWindowController showWindow:nil];

	if (![CDKUser currentUser]) {
		_signInWindowController = [[CDMSignInWindowController alloc] init];
		[_signInWindowController showWindow:nil];
	}

	dispatch_async(dispatch_get_main_queue(), ^{
		// Initialize the connection to Pusher
		[CDKPushController sharedController];
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
