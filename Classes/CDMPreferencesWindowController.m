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
@synthesize colorsPreferenceView = _colorsPreferenceView;
@synthesize playbackPreferenceView = _playbackPreferenceView;
@synthesize updatesPreferenceView = _updatesPreferenceView;
@synthesize advancedPreferenceView = _advancedPreferenceView;

- (void)setupToolbar{
    [self addView:self.generalPreferenceView label:@"General"];
    [self addView:self.colorsPreferenceView label:@"Colors"];
    [self addView:self.playbackPreferenceView label:@"Playback"];
    [self addView:self.updatesPreferenceView label:@"Updates"];
    [self addFlexibleSpacer];
    [self addView:self.advancedPreferenceView label:@"Advanced"];

    // Optional configuration settings.
    [self setCrossFade:[[NSUserDefaults standardUserDefaults] boolForKey:@"fade"]];
    [self setShiftSlowsAnimation:[[NSUserDefaults standardUserDefaults] boolForKey:@"shiftSlowsAnimation"]];
}

@end
