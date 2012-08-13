//
//  CDMTextButton.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTextButton.h"
#import "CDMTextButtonCell.h"

@implementation CDMTextButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    CDMTextButtonCell *cell = [[CDMTextButtonCell alloc] init];
    [cell setAttributedTitle:[self attributedTitle]];
    [cell setTitle:[self title]];
    [cell setTarget:[self target]];
    [cell setAction:[self action]];
    [self setCell:cell];
}

+ (Class)cellClass
{
    return [CDMTextButtonCell class];
}
@end
