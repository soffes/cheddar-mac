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
    NSTextView *_hitTestTextView;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        self.textColor = [NSColor cheddarLightTextColor];
        self.font = [NSFont fontWithName:kCDMRegularFontName size:15.f];
        self.backgroundColor = [NSColor clearColor];
        self.drawsBackground = NO;
        _hitTestTextView = [[NSTextView alloc] initWithFrame:[self frame]];
        [[_hitTestTextView textContainer] setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
        [[_hitTestTextView textContainer] setWidthTracksTextView:NO];
        [_hitTestTextView setHorizontallyResizable:YES];
        [self setPostsFrameChangedNotifications:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textFieldFrameChanged:) name:NSViewFrameDidChangeNotification object:self];
        [_hitTestTextView bind:@"attributedString" toObject:self withKeyPath:@"attributedStringValue" options:nil];
        [self addObserver:self forKeyPath:@"attributedStringValue" options:0 context:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"attributedStringValue"];
    [_hitTestTextView unbind:@"attributedString"];
}

#pragma mark - Mouse Events

- (void)mouseDown:(NSEvent *)theEvent
{
    if ([theEvent clickCount] == 2) {
        [self beginEditing];
    } else {
        // Largely based on this sample code
        // <https://developer.apple.com/library/mac/#samplecode/LayoutManagerDemo/Listings/LayoutManagerDemo_MouseOverTextView_m.html#//apple_ref/doc/uid/DTS10000394-LayoutManagerDemo_MouseOverTextView_m-DontLinkElementID_6>
        NSLayoutManager *layoutManager = [_hitTestTextView layoutManager];
        NSTextContainer *textContainer = [_hitTestTextView textContainer];
        NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        point.y = NSMidY([_hitTestTextView bounds]);
        NSUInteger glyphIndex = [layoutManager glyphIndexForPoint:point inTextContainer:textContainer];
        NSUInteger charIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
        NSAttributedString *string = [_hitTestTextView attributedString];
        NSRect boundingRect = NSMakeRect(0.f, 0.f, [string size].width, [_hitTestTextView frame].size.height);
        if (NSPointInRect(point, boundingRect) && charIndex != NSNotFound && charIndex < [string length]) {
            NSDictionary *attributes = [string attributesAtIndex:charIndex effectiveRange:NULL];
            NSString *link = [attributes valueForKey:NSLinkAttributeName];
            if (link) {
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:link]];
            } else {
                [super mouseDown:theEvent];
            }
        } else {
            [super mouseDown:theEvent];
        }
    }
}

- (void)beginEditing
{
    if ([self.delegate respondsToSelector:@selector(editingTextForTextField:)]) {
        [self setAttributedStringValue:nil];
        [self setStringValue:[(id)self.delegate editingTextForTextField:self]];
        [self setEditable:YES];
    }
    [[self window] makeFirstResponder:self];
    NSTextView *fieldEditor = (NSTextView*)[[self window] fieldEditor:NO forObject:self];
    [fieldEditor scrollRangeToVisible:NSMakeRange ([[fieldEditor string] length], 0)];
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    [super textDidEndEditing:notification];
    [self setEditable:NO];
}

- (void)resetCursorRects
{
    [super resetCursorRects];
    NSAttributedString *string = [_hitTestTextView attributedString];
    NSLayoutManager *layoutManager = [_hitTestTextView layoutManager];
    [string enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, [string length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            NSRange glyphRange = [layoutManager glyphRangeForCharacterRange:range actualCharacterRange:NULL];
            NSRect boundingRect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:[_hitTestTextView textContainer]];
            [self addCursorRect:boundingRect cursor:[NSCursor pointingHandCursor]];
        }
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"attributedStringValue"]) {
        [self resetCursorRects];
    }
}
#pragma mark - Private

- (void)_textFieldFrameChanged:(NSNotification *)notification
{
    [_hitTestTextView setFrame:[self frame]];
}
@end
