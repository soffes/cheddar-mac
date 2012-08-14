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
#import "CDMFlatButton.h"
#import "NSColor+CDMAdditions.h"

static CGFloat const kCDMMainWindowControllerMinLeftWidth = 100.f;
static NSString* const kCDMLastDividerPositionKey = @"CDMLastDividerPosition";

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
@synthesize splitView = _splitView;


#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userChanged:) name:kCDKCurrentUserChangedNotificationName object:nil];
	}
	return self;
}

#pragma mark - Actions

- (IBAction)toggleSidebar:(id)sender {
    if (![self.splitViewLeft isHidden]) {
        [self.splitView setPosition:0.f ofDividerAtIndex:0];
    } else {
        [self.splitView setPosition:[[NSUserDefaults standardUserDefaults] floatForKey:kCDMLastDividerPositionKey] ofDividerAtIndex:0];
    }
}

#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"MainWindow";
}


- (void)windowDidLoad {
    [super windowDidLoad];
    [[NSUserDefaults standardUserDefaults] setFloat:NSMaxX([self.splitViewLeft frame]) forKey:kCDMLastDividerPositionKey];
}


- (void)showWindow:(id)sender {
	if (![CDKUser currentUser]) {
		return;
	}
	[super showWindow:sender];
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
    // Only prevent the subview from resizing when the user is resizing the window
    // We don't want to prevent any other cases where the view may be resized (e.g. restoring autosave)
    return subview != self.splitViewLeft && [[self window] inLiveResize];
}


// Good docs here <http://manicwave.com/blog/2009/12/28/unraveling-the-mysteries-of-nssplitview-part-1/>
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex {
    return proposedMin + kCDMMainWindowControllerMinLeftWidth;
}


- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
    // Allow for the collapsing of the sidebar
    return subview == self.splitViewLeft;
}


- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification {
    if (![self.splitViewLeft isHidden]) {
        [[NSUserDefaults standardUserDefaults] setFloat:NSMaxX([self.splitViewLeft frame]) forKey:kCDMLastDividerPositionKey];
    }
}


#pragma mark - NSMenuDelegate

- (void)menuNeedsUpdate:(NSMenu *)menu {
    NSMenuItem *showHide = [menu itemAtIndex:0];
    [showHide setTitle:NSLocalizedString([self.splitViewLeft isHidden] ? @"Show Sidebar" : @"Hide Sidebar", nil)];
    [showHide setTarget:self];
    [showHide setAction:@selector(toggleSidebar:)];
}


- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
	if (![CDKUser currentUser]) {
		if ([menuItem.title isEqualToString:@"Hide Sidebar"] || [menuItem.title isEqualToString:@"Show Sidebar"]) {
			return NO;
		}
	}
	return YES;
}

@end
