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
#import "CDMAppDelegate.h"
#import "NSColor+CDMAdditions.h"

@interface CDMPlusWindowContentView ()
- (void)_userUpdated:(NSNotification *)notification;
@end

@implementation CDMPlusWindowController

@synthesize parentWindow = _parentWindow;
@synthesize dialogView = _dialogView;
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;

- (void)setParentWindow:(NSWindow *)parentWindow {
    [(CDMPlusWindow*)[self window] setParentWindow:parentWindow];
}


- (NSWindow*)parentWindow {
    return [(CDMPlusWindow*)[self window] parentWindow];
}


#pragma mark - NSObject

- (void)awakeFromNib {
	[super awakeFromNib];

	self.titleLabel.font = [NSFont fontWithName:kCDMBoldFontName size:16.0f];
	self.titleLabel.textColor = [NSColor cheddarSteelColor];
	
	self.messageLabel.font = [NSFont fontWithName:kCDMRegularFontName size:14.0f];
	self.messageLabel.textColor = [NSColor cheddarTextColor];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userUpdated:) name:kCDKUserUpdatedNotificationName object:nil];
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"Plus";
}


#pragma mark - Actions

- (IBAction)upgrade:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://cheddarapp.com/account#plus"]];
}


#pragma mark - Private

- (void)_userUpdated:(NSNotification *)notification {
	if ([CDKUser currentUser] && [[[CDKUser currentUser] hasPlus] boolValue]) {
		[(CDMAppDelegate *)[NSApp delegate] dismissPlusWindow:nil];
	}
}

@end
