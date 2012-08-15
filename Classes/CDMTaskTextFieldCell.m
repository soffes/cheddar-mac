//
//  CDMTaskTextFieldCell.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTaskTextFieldCell.h"
#import "NSColor+CDMAdditions.h"
#import "NSTextView+CDMAdditions.h"

@implementation CDMTaskTextFieldCell

- (NSText*)setUpFieldEditorAttributes:(NSText *)textObj {
    NSTextView *textView = (NSTextView*)[super setUpFieldEditorAttributes:textObj];
    NSDictionary *linkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:kCDMRegularFontName size:15.f], NSFontAttributeName, [NSColor cheddarBlueColor] , NSForegroundColorAttributeName, [NSCursor pointingHandCursor], NSCursorAttributeName, nil];
    [textView setLinkTextAttributes:linkAttributes];
    [textView setUseCustomContextMenu:YES];
    return textView;
}

@end
