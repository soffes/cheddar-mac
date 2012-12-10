//
//  CDMSignInWindowController.h
//  Cheddar
//
//  Created by Sam Soffes on 6/14/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@class CDMFlatButton;

@interface CDMSignInWindowController : NSWindowController

@property (nonatomic, weak) IBOutlet NSTextField *usernameTextField;
@property (nonatomic, weak) IBOutlet NSSecureTextField *passwordTextField;
@property (nonatomic, weak) IBOutlet NSTextField *usernameLabel;
@property (nonatomic, weak) IBOutlet NSTextField *passwordLabel;
@property (nonatomic, weak) IBOutlet CDMFlatButton *signUpButton;
@property (nonatomic, weak) IBOutlet CDMFlatButton *signInButton;

- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)forgotPassword:(id)sender;

@end
