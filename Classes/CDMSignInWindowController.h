//
//  CDMSignInWindowController.h
//  Cheddar
//
//  Created by Sam Soffes on 6/14/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@class CDMFlatButton;
@interface CDMSignInWindowController : NSWindowController

@property (weak) IBOutlet NSTextField *usernameTextField;
@property (weak) IBOutlet NSSecureTextField *passwordTextField;
@property (weak) IBOutlet NSTextField *usernameLabel;
@property (weak) IBOutlet NSTextField *passwordLabel;
@property (weak) IBOutlet CDMFlatButton *signUpButton;
@property (weak) IBOutlet CDMFlatButton *signInButton;
- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)forgotPassword:(id)sender;

@end
