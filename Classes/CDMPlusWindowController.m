//
//  CDMPlusWindowController.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMPlusWindowController.h"
#import "CDMPlusWindow.h"
#import <QuartzCore/QuartzCore.h>

@interface CDMPlusWindowController ()

@end

@implementation CDMPlusWindowController
@synthesize parentWindow = _parentWindow;
@synthesize dialogView = _dialogView;

#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"Plus";
}

#pragma mark - Accessors

- (void)setParentWindow:(NSWindow *)parentWindow
{
    [(CDMPlusWindow*)[self window] setParentWindow:parentWindow];
}

- (NSWindow*)parentWindow
{
    return [(CDMPlusWindow*)[self window] parentWindow];
}

#pragma mark - Actions

- (IBAction)animateDialogViewOffScreen:(id)sender
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    NSRect newDialogFrame = [self.dialogView frame];
    newDialogFrame.origin.y = NSMaxY([[[self window] contentView] bounds]);
    [[self.dialogView animator] setFrame:newDialogFrame];
    [NSAnimationContext endGrouping];
}
@end
