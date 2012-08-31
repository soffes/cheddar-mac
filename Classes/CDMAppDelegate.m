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
#import "CDMPlusWindowController.h"
#import "CDMQuickAddWindowController.h"
#import "MASShortcutView+UserDefaults.h"
#import "MASShortcut+UserDefaults.h"

@interface CDMAppDelegate ()
- (void)_userChanged:(NSNotification *)notification;
- (void)_showPlusWindowIfNecessary;
- (void)_mainWindowResized:(NSNotification*)notification;
@end

@implementation CDMAppDelegate {
    CDMPlusWindowController *_plusWindowController;
    CDMQuickAddWindowController *_quickAddWindowController;
}

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
	} else {
		if ([[[CDKUser currentUser] hasPlus] boolValue] == NO) {
			[self performSelector:@selector(_showPlusWindowIfNecessary) withObject:nil afterDelay:0.25f];
		}
	}
}


- (void)_showPlusWindowIfNecessary {
    NSWindow *mainWindow = [_mainWindowController window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_mainWindowResized:) name:NSWindowDidResizeNotification object:mainWindow];

    _plusWindowController = [[CDMPlusWindowController alloc] init];
    _plusWindowController.parentWindow = mainWindow;

    [self.mainWindowController.taskTextField setEnabled:NO];
    NSWindow *overlayWindow = [_plusWindowController window];
    [overlayWindow setAlphaValue:0.f];
    [overlayWindow setFrame:[mainWindow frame] display:YES animate:NO];
    [mainWindow addChildWindow:overlayWindow ordered:NSWindowAbove];
    [overlayWindow makeKeyAndOrderFront:nil];
    [[overlayWindow animator] setAlphaValue:1.f];
}


- (IBAction)dismissPlusWindow:(id)sender {
    if (!_plusWindowController) {
		return;
	}
    NSWindow *mainWindow = [_mainWindowController window];
    NSWindow *overlayWindow = [_plusWindowController window];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [mainWindow removeChildWindow:overlayWindow];
        [self.mainWindowController.taskTextField setEnabled:YES];
        [overlayWindow close];
        _plusWindowController = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:mainWindow];
    }];
    [[overlayWindow animator] setAlphaValue:0.f];
    [NSAnimationContext endGrouping];
}


- (void)_mainWindowResized:(NSNotification*)notification {
    NSWindow *mainWindow = [_mainWindowController window];
    NSWindow *overlayWindow = [_plusWindowController window];
    [overlayWindow setFrame:[mainWindow frame] display:YES animate:NO];
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
    _mainWindowController.listMenu = self.listMenu;
	[_mainWindowController showWindow:nil];
    
    _quickAddWindowController = [[CDMQuickAddWindowController alloc] init];

	if (![CDKUser currentUser]) {
		[self.signInWindowController showWindow:nil];
	}
    
    
    // Configure shortcuts
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![[ud objectForKey:kCDMUserDefaultsQuickAddShortcutKey] isKindOfClass:[NSData class]]) {
        // Set up the default search shortcut
        MASShortcut *shortcut = [MASShortcut shortcutWithKeyCode:kVK_ANSI_N modifierFlags:NSCommandKeyMask | NSAlternateKeyMask | NSShiftKeyMask];
        [ud setObject:[shortcut data] forKey:kCDMUserDefaultsQuickAddShortcutKey];
    }
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:kCDMUserDefaultsQuickAddShortcutKey handler:^{
        [_quickAddWindowController showWindow:nil];
    }];

	dispatch_async(dispatch_get_main_queue(), ^{
		// Initialize the connection to Pusher
		[CDKPushController sharedController];

		// Add observer for user change
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userChanged:) name:kCDKCurrentUserChangedNotificationName object:nil];
		[self _userChanged:nil];
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

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    if ([CDKUser currentUser])
        [_mainWindowController.window makeKeyAndOrderFront:nil];
    return YES;
}
@end
