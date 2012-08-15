//
//  NSTextView+CDMAdditions.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-15.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "NSTextView+CDMAdditions.h"
#import "NSObject+AssociatedObjects.h"
#import "JRSwizzle.h"

static void* kCDMTextViewUseCustomContextMenuKey = @"CDMUseCustomContextMenu";

@implementation NSTextView (CDMAdditions)

+ (void)load {
    // Swizzle the method implementations so that our swizzled method gets called instead of the original when NSTextView requests a menu
    // More info on this technique here <http://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html>
    [NSTextView jr_swizzleMethod:@selector(menuForEvent:) withMethod:@selector(menuForEvent_swizzle:) error:nil];
}

- (NSMenu*)menuForEvent_swizzle:(NSEvent *)event
{
    // This gets a reference to the original menu created by NSTextView in case we want to take items from it
    NSMenu *superMenu = [self menuForEvent_swizzle:event];
    // Return our own custom menu if that property has been set, otherwise return the default one 
    if ([self useCustomContextMenu]) {
        NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Testing"];
        [menu addItemWithTitle:@"Testing" action:nil keyEquivalent:@""];
        [menu setAllowsContextMenuPlugIns:NO];
        return menu;
    }
    return superMenu;
}

#pragma mark - Accessors

- (void)setUseCustomContextMenu:(BOOL)useCustomContextMenu
{
    [self associateValue:[NSNumber numberWithBool:useCustomContextMenu] withKey:kCDMTextViewUseCustomContextMenuKey];
}

- (BOOL)useCustomContextMenu
{
    return [[self associatedValueForKey:kCDMTextViewUseCustomContextMenuKey] boolValue];
}
@end
