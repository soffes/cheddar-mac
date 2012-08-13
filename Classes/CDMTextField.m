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
    [self setCell:[[CDMTextFieldCell alloc] initTextCell:[self stringValue]]];
}

+ (Class)cellClass
{
    return [CDMTextFieldCell class];
}
@end
