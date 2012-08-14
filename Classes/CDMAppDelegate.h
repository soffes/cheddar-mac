//
//  CDMAppDelegate.h
//  Cheddar for Mac
//
//  Created by Sam Soffes on 6/14/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

@class CDMSignInWindowController;
@class CDMMainWindowController;

@interface CDMAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong, readonly) CDMSignInWindowController *signInWindowController;
@property (nonatomic, strong, readonly) CDMMainWindowController *mainWindowController;

+ (CDMAppDelegate *)sharedAppDelegate;

- (IBAction)showMainWindow:(id)sender;
- (IBAction)addList:(id)sender;
@end
