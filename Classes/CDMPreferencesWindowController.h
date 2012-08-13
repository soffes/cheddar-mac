//
//  CDMPreferencesWindowController.h
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/13/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "DBPrefsWindowController.h"

@interface CDMPreferencesWindowController : DBPrefsWindowController

@property (strong, nonatomic) IBOutlet NSView *generalPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *colorsPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *playbackPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *updatesPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *advancedPreferenceView;

@end
