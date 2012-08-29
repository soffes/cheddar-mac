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

- (NSText *)setUpFieldEditorAttributes:(NSText *)textObj
{
    NSTextView *textView = (NSTextView *)[super setUpFieldEditorAttributes:textObj];
  //  [textView setDrawsBackground:NO];
    [textView setBackgroundColor:[NSColor clearColor]];
  //  [[textView enclosingScrollView] setDrawsBackground:NO];
    [[textView enclosingScrollView] setBackgroundColor:[NSColor clearColor]];
    return textView;
}

- (NSRect)adjustedFrameToVerticallyCenterText:(NSRect)frame {
	NSInteger offset = floor((NSHeight(frame) - ([[self font] ascender] - [[self font] descender])) / 2);
	return NSInsetRect(frame, 0.f, offset);
}


- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)editor delegate:(id)delegate event:(NSEvent *)event {
	[super editWithFrame:[self adjustedFrameToVerticallyCenterText:aRect] inView:controlView editor:editor delegate:delegate event:event];
}


- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)editor delegate:(id)delegate start:(NSInteger)start length:(NSInteger)length {
	[super selectWithFrame:[self adjustedFrameToVerticallyCenterText:aRect] inView:controlView editor:editor delegate:delegate start:start length:length];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [super drawInteriorWithFrame:[self adjustedFrameToVerticallyCenterText:cellFrame] inView:controlView];
}
@end
