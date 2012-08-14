//
//  CDMPlusWindowController.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMPlusWindowController.h"
#import "CDMPlusWindow.h"

@interface CDMPlusWindowController ()

@end

@implementation CDMPlusWindowController
@synthesize parentWindow = _parentWindow;

#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"Plus";
}

#pragma mark - Accessors

- (void)setParentWindow:(NSWindow *)parentWindow
{
    [(CDMPlusWindow*)[self window] setParentWindow:parentWindow];
}

- (NSWindow*)parentWindow
{
    return [(CDMPlusWindow*)[self window] parentWindow];
}
@end
