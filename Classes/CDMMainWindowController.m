//
//  CDMMainWindowController.m
//  Cheddar
//
//  Created by Sam Soffes on 6/15/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMMainWindowController.h"
#import "INAppStoreWindow.h"
#import "CDMListsViewController.h"
#import "CDMTasksViewController.h"

void SSDrawGradientInRect(CGContextRef context, CGGradientRef gradient, CGRect rect) {
	CGContextSaveGState(context);
	CGContextClipToRect(context, rect);
	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
	CGContextDrawLinearGradient(context, gradient, start, end, 0);
	CGContextRestoreGState(context);
}

@interface CDMMainWindowController ()
- (void)_userChanged:(NSNotification *)notification;
@end

@implementation CDMMainWindowController

@synthesize listsViewController = _listsViewController;
@synthesize tasksViewController = _tasksViewController;
@synthesize splitViewLeft = _splitViewLeft;
@synthesize createListPanel = _createListPanel;


#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userChanged:) name:kCDKCurrentUserChangedNotificationName object:nil];
	}
	return self;
}


#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"MainWindow";
}


- (void)showWindow:(id)sender {
	if (![CDKUser currentUser]) {
		return;
	}

	[super showWindow:sender];
}


#pragma mark - Actions

- (IBAction)createList:(id)sender {
	[NSApp beginSheet:self.createListPanel modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}


#pragma mark - Private

- (void)_userChanged:(NSNotification *)notification {
	if ([CDKUser currentUser]) {
		[self showWindow:nil];
	} else {
		[self close];
	}
}


#pragma mark - NSSplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview {
    // Don't resize the sidebar
    return subview != self.splitViewLeft;
}


#pragma mark - NSWindowDelegate

//- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect {
//	CGFloat width = rect.size.width;
//	return CGRectMake(roundf((window.frame.size.width - width) / 2.0f), 40.0f, width, 1.0f);
//}

@end
