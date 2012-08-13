//
//  NSView+CDMAdditions.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "NSView+CDMAdditions.h"

@implementation NSView (CDMAdditions)
- (BOOL)isFirstResponder
{
    if ([self isKindOfClass:[NSTextField class]]) {
        return ([[[self window] firstResponder] isKindOfClass:[NSTextView class]]
                && [[self window] fieldEditor:NO forObject:nil]
                && [self isEqualTo:(id)[(NSTextView *)[[self window] firstResponder]delegate]]);
    } else {
       return ([[self window] firstResponder] == self);
    }
}
@end
