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
    [self setCell:[[CDMSecureTextFieldCell alloc] initTextCell:[self stringValue]]];
}

+ (Class)cellClass
{
    return [CDMSecureTextFieldCell class];
}
@end
