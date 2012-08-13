//
//  CDMSecureTextField.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMSecureTextField.h"
#import "CDMSecureTextFieldCell.h"

@implementation CDMSecureTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    CDMSecureTextFieldCell *cell = [[CDMSecureTextFieldCell alloc] initTextCell:[self stringValue]];
    [cell setTarget:[self target]];
    [cell setAction:[self action]];
    [self setCell:cell];
}

+ (Class)cellClass
{
    return [CDMSecureTextFieldCell class];
}
@end
