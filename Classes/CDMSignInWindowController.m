//
//  CDMSignInWindowController.m
//  Cheddar
//
//  Created by Sam Soffes on 6/14/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMSignInWindowController.h"
#import "NSColor+CDMAdditions.h"
#import "CDMFlatButton.h"

@implementation CDMSignInWindowController

@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize signInButton = _signInButton;
@synthesize signUpButton = _signUpButton;

#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"SignIn";
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.signInButton setButtonColor:[NSColor cheddarSteelColor]];
    [self.signUpButton setButtonColor:[NSColor cheddarOrangeColor]];
}

#pragma mark - Actions

- (IBAction)signIn:(id)sender {
	[[CDKHTTPClient sharedClient] signInWithLogin:self.usernameTextField.stringValue password:self.passwordTextField.stringValue success:^(AFJSONRequestOperation *operation, id responseObject) {
		NSLog(@"signed in");
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		NSLog(@"Failed: %@", error);
	}];
}


- (IBAction)signUp:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://cheddarapp.com/signup"]];
}


- (IBAction)forgotPassword:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://cheddarapp.com/forgot"]];
}

@end
