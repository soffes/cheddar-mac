//
//  CDMTextFieldCell.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTextFieldCell.h"
#import "NSBezierPath+MCAdditions.h"

static CGFloat const kCDMTextFieldCellXInset = 10.0f;
static CGFloat const kCDMTextFieldCellCornerRadius = 4.0f;
static CGFloat const kCDMTextFieldCellShadowBlurRadius = 4.0f;

@implementation CDMTextFieldCell
- (void)awakeFromNib {
	[super awakeFromNib];
	self.font = [NSFont fontWithName:kCDMRegularFontName size:16.0];
	self.textColor = [NSColor colorWithCalibratedRed:0.200 green:0.200 blue:0.200 alpha:1];
    [self setDrawsBackground:NO];
    [self setBordered:NO];
    [self setBezeled:NO];
    [self setFocusRingType:NSFocusRingTypeNone];
}

// From http://stackoverflow.com/a/8626071/118631
- (NSRect)adjustedFrameToVerticallyCenterText:(NSRect)frame {
	NSInteger offset = floor((NSHeight(frame) - ([[self font] ascender] - [[self font] descender])) / 2);
	return NSInsetRect(frame, kCDMTextFieldCellXInset, offset);
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)editor delegate:(id)delegate event:(NSEvent *)event {
	[super editWithFrame:[self adjustedFrameToVerticallyCenterText:aRect] inView:controlView editor:editor delegate:delegate event:event];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)editor delegate:(id)delegate start:(NSInteger)start length:(NSInteger)length {
	[super selectWithFrame:[self adjustedFrameToVerticallyCenterText:aRect] inView:controlView editor:editor delegate:delegate start:start length:length];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSColor *borderColor = [NSColor colorWithDeviceRed:0.72 green:0.73 blue:0.76 alpha:1.0];
    NSColor *fillColor = [NSColor whiteColor];
    NSColor *shadowColor = [NSColor colorWithDeviceWhite:0.f alpha:0.3f];
    NSRect drawingRect = NSInsetRect(cellFrame, 1.f, 1.f);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:drawingRect xRadius:kCDMTextFieldCellCornerRadius yRadius:kCDMTextFieldCellCornerRadius];
    [borderColor setStroke];
    [fillColor setFill];
    [path fill];
    [path stroke];
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowBlurRadius:kCDMTextFieldCellShadowBlurRadius];
    [shadow setShadowColor:shadowColor];
    NSRect shadowRect = drawingRect;
    // Add space on each of the dimensions that we don't want the shadow showing through
    shadowRect.size.height += 20.f;
    shadowRect.origin.x -= 20.f;
    shadowRect.size.width += 40.f;
    NSBezierPath *shadowPath = [NSBezierPath bezierPathWithRect:shadowRect];
    [NSGraphicsContext saveGraphicsState];
    [path addClip];
    [shadowPath fillWithInnerShadow:shadow];
    [NSGraphicsContext restoreGraphicsState];
    [super drawInteriorWithFrame:[self adjustedFrameToVerticallyCenterText:cellFrame] inView:controlView];
}
@end
