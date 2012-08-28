//
//  CDMTaskTextFieldCell.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTaskTextFieldCell.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMTaskTextFieldCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self setDrawsBackground:NO];
        [self setBackgroundColor:[NSColor clearColor]];
    }
    return self;
}
@end
