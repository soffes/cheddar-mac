//
//  CDMTextField.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTextField.h"
#import "CDMTextFieldCell.h"

@implementation CDMTextField
- (void)awakeFromNib
{
    [super awakeFromNib];
    CDMTextFieldCell *cell = [[CDMTextFieldCell alloc] initTextCell:[self stringValue]];
    [cell setTarget:[self target]];
    [cell setAction:[self action]];
    [self setCell:cell];
}

+ (Class)cellClass
{
    return [CDMTextFieldCell class];
}
@end
