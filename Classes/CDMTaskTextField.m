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
        NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Testing"];
        [menu addItemWithTitle:@"Copy" action:@selector(copy:) keyEquivalent:@""];
        [menu addItemWithTitle:@"Edit" action:nil keyEquivalent:@""];
        [menu addItemWithTitle:@"Archive" action:nil keyEquivalent:@""];
        [menu setAllowsContextMenuPlugIns:NO];
        [self setMenu:menu];
    }
    return self;
}


@end
