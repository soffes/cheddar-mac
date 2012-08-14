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

@implementation CDMMainWindowController
@synthesize listsViewController = _listsViewController;
@synthesize tasksViewController = _tasksViewController;
@synthesize splitViewLeft = _splitViewLeft;

#pragma mark - NSSplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview
{
    // Don't resize the sidebar
    return subview != self.splitViewLeft;
}
@end
