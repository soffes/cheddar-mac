//
//  CDMTaskTextField.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTaskTextField.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMTaskTextField {
    BOOL _clickEditingEnabled;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        self.textColor = [NSColor cheddarLightTextColor];
        self.font = [NSFont fontWithName:kCDMRegularFontName size:15.f];
    }
    return self;
}

#pragma mark - Mouse Events

- (void)mouseDown:(NSEvent *)theEvent
{
    if ([self.delegate respondsToSelector:@selector(editingTextForTextField:)] && [theEvent clickCount] == 2) {
        [self setAttributedStringValue:nil];
        [self setStringValue:[(id)self.delegate editingTextForTextField:self]];
        [self setEditable:YES];
        [[self window] makeFirstResponder:self];
    } else {
        [super mouseDown:theEvent];
    }
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    [super textDidEndEditing:notification];
    [self setEditable:NO];
}
@end
