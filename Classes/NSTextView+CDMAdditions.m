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

+ (void)load {
    // Swizzle the method implementations so that our swizzled method gets called instead of the original when NSTextView requests a menu
    // More info on this technique here <http://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html>
    [NSTextView jr_swizzleMethod:@selector(menuForEvent:) withMethod:@selector(menuForEvent_swizzle:) error:nil];
}

- (NSMenu*)menuForEvent_swizzle:(NSEvent *)event
{
    // Return our own custom menu if that property has been set, otherwise return the default one 
    if ([self isFieldEditor] && [[self window] firstResponder] == self) {
        NSTextField *textField = (NSTextField*)[self delegate];
        if ([textField menu]) { return [textField menu]; }
    }
    return [self menuForEvent_swizzle:event];
}
@end
