//
//  CDMSignInWindowController.h
//  Cheddar
//
//  Created by Sam Soffes on 6/14/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDMSignInWindowController : NSWindowController

@property (weak) IBOutlet NSTextField *usernameTextField;
@property (weak) IBOutlet NSSecureTextField *passwordTextField;

- (IBAction)signIn:(id)sender;

@end
