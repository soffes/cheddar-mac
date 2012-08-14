//
//  CDMTaskTextFieldCell.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTaskTextFieldCell.h"
#import "NSColor+CDMAdditions.h"

@implementation CDMTaskTextFieldCell

- (NSText*)setUpFieldEditorAttributes:(NSText *)textObj
{
    NSTextView *textView = (NSTextView*)textObj;
    NSDictionary *linkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:kCDMRegularFontName size:15.f], NSFontAttributeName, [NSColor cheddarBlueColor] , NSForegroundColorAttributeName, [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle], NSUnderlineStyleAttributeName, [NSCursor pointingHandCursor], NSCursorAttributeName, nil];
    [textView setLinkTextAttributes:linkAttributes];
    return textView;
}

@end
