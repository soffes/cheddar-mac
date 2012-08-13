//
//  CDMPreferencesWindowController.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/13/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMPreferencesWindowController.h"

@implementation CDMPreferencesWindowController

@synthesize generalPreferenceView = _generalPreferenceView;
@synthesize accountPreferenceView = _accountPreferenceView;
@synthesize updatesPreferenceView = _updatesPreferenceView;

- (void)setupToolbar{
    [self addView:self.generalPreferenceView label:@"General" image:[NSImage imageNamed:@"NSPreferencesGeneral"]];
    [self addView:self.accountPreferenceView label:@"Account" image:[NSImage imageNamed:@"NSUser"]];
    [self addView:self.updatesPreferenceView label:@"Updates" image:[NSImage imageNamed:@"preferences-updates"]];

    [self setCrossFade:YES];
    [self setShiftSlowsAnimation:YES];
}

@end
