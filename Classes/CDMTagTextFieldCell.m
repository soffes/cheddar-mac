//
//  CDMTagTextFieldCell.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-15.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTagTextFieldCell.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMTagTextFieldCell
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.font = [NSFont fontWithName:kCDMRegularFontName size:15.0];
        self.textColor = [NSColor whiteColor];
    }
    return self;
}

@end
