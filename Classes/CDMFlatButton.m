//
//  CDMFlatButton.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMFlatButton.h"
#import "CDMFlatButtonCell.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMFlatButton

@synthesize buttonColor = _buttonColor;

- (void)awakeFromNib {
    [super awakeFromNib];

    CDMFlatButtonCell *cell = [[CDMFlatButtonCell alloc] init];
    [cell setAttributedTitle:[self attributedTitle]];
    [cell setTitle:[self title]];
    [cell setTarget:[self target]];
    [cell setAction:[self action]];
	[cell setButtonColor:[NSColor cheddarOrangeColor]];
    [self setCell:cell];
}


+ (Class)cellClass {
    return [CDMFlatButtonCell class];
}


#pragma mark - Accessors

- (void)setButtonColor:(NSColor *)buttonColor {
    [[self cell] setButtonColor:buttonColor];
}


- (NSColor*)buttonColor {
    return [[self cell] buttonColor];
}

@end
