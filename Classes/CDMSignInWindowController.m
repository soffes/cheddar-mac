//
//  CDMSignInWindowController.m
//  Cheddar
//
//  Created by Sam Soffes on 6/14/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMSignInWindowController.h"
#import "CDMAppDelegate.h"
#import "CDMMainWindowController.h"
#import "CDMArchesWindow.h"
#import "CDMListsViewController.h"
#import "NSColor+CDMAdditions.h"
#import "CDMFlatButton.h"

#define CDMSignInWindowControllerLabelTextColor [NSColor colorWithDeviceWhite:0.267f alpha:1.f]
#define CDMSignInWindowControllerFont [NSFont fontWithName:kCDMRegularFontName size:14.0]

@implementation CDMSignInWindowController

#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"SignIn";
}


- (void)windowDidLoad {
	[super windowDidLoad];

	[self.signUpButton setButtonColor:[NSColor cheddarSteelColor]];
	[self.signInButton setButtonColor:[NSColor cheddarOrangeColor]];

	NSColor *color = CDMSignInWindowControllerLabelTextColor;
	NSFont *font = CDMSignInWindowControllerFont;

	[self.usernameLabel setTextColor:color];
	[self.usernameLabel setFont:font];

	[self.passwordLabel setTextColor:color];
	[self.passwordLabel setFont:font];
}


#pragma mark - Actions

- (IBAction)signIn:(id)sender {
	if (self.usernameTextField.stringValue.length == 0 || self.passwordTextField.stringValue.length == 0) {
		CDMArchesWindow *archesWindow = (CDMArchesWindow *)self.window;
		[archesWindow shake:nil];
		return;
	}
	
	[[CDKHTTPClient sharedClient] signInWithLogin:self.usernameTextField.stringValue password:self.passwordTextField.stringValue success:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.usernameTextField becomeFirstResponder];
			[self close];
			self.usernameTextField.stringValue = @"";
			self.passwordTextField.stringValue = @"";
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			CDMArchesWindow *archesWindow = (CDMArchesWindow *)self.window;
			[archesWindow shake:nil];
		});
    }];
}


- (IBAction)signUp:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://cheddarapp.com/signup"]];
}


- (IBAction)forgotPassword:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://cheddarapp.com/forgot"]];
}

@end
