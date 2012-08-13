//
//  CDMAppDelegate.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 6/14/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "CDMAppDelegate.h"
#import "CDMSignInWindowController.h"
#import "CDMListsWindowController.h"
#import "CDMDefines.h"

@implementation CDMAppDelegate {
	CDMSignInWindowController *_signInWindowController;
	CDMListsWindowController *_listsWindowController;
}

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
	
	//if (![CDKUser currentUser]) {
		_signInWindowController = [[CDMSignInWindowController alloc] init];
		[_signInWindowController.window makeKeyAndOrderFront:nil];
	//} else {
		_listsWindowController = [[CDMListsWindowController alloc] init];
		[_listsWindowController.window makeKeyAndOrderFront:nil];
	//}

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
