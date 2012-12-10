//
//  CDMAboutWindowController.h
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/13/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface CDMAboutWindowController : NSWindowController

@property (nonatomic, weak) IBOutlet NSTextField *subheaderLabel;
@property (nonatomic, weak) IBOutlet NSTextField *versionLabel;
@property (nonatomic, weak) IBOutlet NSTextField *copyrightLabel;

@end
