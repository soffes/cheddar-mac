//
//  NSTextView+CDMAdditions.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-15.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "NSTextView+CDMAdditions.h"
#import "JRSwizzle.h"

@implementation NSTextView (CDMAdditions)

+ (void)swizzle {
    [NSTextView jr_swizzleMethod:@selector(menuForEvent:) withMethod:@selector(menuForEvent_swizzle:) error:nil];
}

- (NSMenu*)menuForEvent:(NSEvent *)event
{
    [NSTextView jr_swizzleMethod:@selector(menuForEvent:) withMethod:@selector(menuForEvent_swizzle:) error:nil];
    NSMenu *superMenu = [self menuForEvent:event];
    [NSTextView jr_swizzleMethod:@selector(menuForEvent:) withMethod:@selector(menuForEvent_swizzle:) error:nil];
    NSLog(@"%@", superMenu);
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Testing"];
    [menu addItemWithTitle:@"Testing" action:nil keyEquivalent:@""];
    [menu setAllowsContextMenuPlugIns:NO];
    return menu;
}
@end
