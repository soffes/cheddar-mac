//
//  CDMAddListTextFieldCell.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMAddListTextFieldCell.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMAddListTextFieldCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.font = [NSFont fontWithName:kCDMRegularFontName size:14.0];
        self.textColor = [NSColor cheddarTextColor];
        [self setDrawsBackground:NO];
        [self setBordered:NO];
        [self setBezeled:NO];
        [self setFocusRingType:NSFocusRingTypeNone];
        [self setEditable:YES];
    }
    return self;
}

@end
