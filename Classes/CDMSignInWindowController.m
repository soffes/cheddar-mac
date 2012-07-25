//
//  CDMSignInWindowController.m
//  Cheddar
//
//  Created by Sam Soffes on 6/14/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMSignInWindowController.h"

@implementation CDMSignInWindowController

@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;


#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"SignIn";
}


#pragma mark - Actions

- (IBAction)signIn:(id)sender {
	[[CDKHTTPClient sharedClient] signInWithLogin:self.usernameTextField.stringValue password:self.passwordTextField.stringValue success:^(AFJSONRequestOperation *operation, id responseObject) {
		NSLog(@"signed in");
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		NSLog(@"Failed: %@", error);
	}];
}

@end
