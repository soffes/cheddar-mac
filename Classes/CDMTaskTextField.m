//
//  CDMTaskTextField.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTaskTextField.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMTaskTextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        self.textColor = [NSColor cheddarLightTextColor];
        self.font = [NSFont fontWithName:kCDMRegularFontName size:15.f];
    }
    return self;
}


@end
