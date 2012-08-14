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

@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize signInButton = _signInButton;
@synthesize signUpButton = _signUpButton;
@synthesize usernameLabel = _usernameLabel;
@synthesize passwordLabel = _passwordLabel;

#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"SignIn";
}


- (void)windowDidLoad {
	[super windowDidLoad];

	CDMArchesWindow *archesWindow = (CDMArchesWindow *)self.window;
	archesWindow.closeEnabled = NO;

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
	[[CDKHTTPClient sharedClient] signInWithLogin:self.usernameTextField.stringValue password:self.passwordTextField.stringValue success:^(AFJSONRequestOperation *operation, id responseObject) {
		[self.usernameTextField becomeFirstResponder];
		[self close];
		self.usernameTextField.stringValue = @"";
		self.passwordTextField.stringValue = @"";
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		CDMArchesWindow *archesWindow = (CDMArchesWindow *)self.window;
        dispatch_async(dispatch_get_main_queue(), ^{
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
