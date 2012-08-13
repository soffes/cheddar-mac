//
//  CDMSecureTextFieldCell.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMSecureTextFieldCell.h"
#import "NSBezierPath+MCAdditions.h"
#import "NSColor+CDMAdditions.h"
#import "NSView+CDMAdditions.h"

static CGFloat const kCDMTextFieldCellXInset = 10.0f;
static CGFloat const kCDMTextFieldCellCornerRadius = 4.0f;
static CGFloat const kCDMTextFieldCellInnerShadowBlurRadius = 2.0f;
static CGFloat const kCDMTextFieldCellOuterShadowBlurRadius = 2.0f;
#define kCDMTextFieldCellInnerShadowColor [NSColor colorWithDeviceWhite:0.0 alpha:0.3f]
#define kCDMTextFieldCellOuterShadowColor [[NSColor cheddarOrangeColor] colorWithAlphaComponent:0.5f]
#define kCDMTextFieldCellFillColor [NSColor whiteColor]

@implementation CDMSecureTextFieldCell
- (void)awakeFromNib {
	[super awakeFromNib];
    NSLog(@"%@", NSStringFromClass([self class]));
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
    NSLog(@"draw interior");
    CGFloat scaleFactor = [[controlView window] backingScaleFactor];
    BOOL firstResponder = [controlView isFirstResponder];
    NSRect drawingRect = NSInsetRect(cellFrame, kCDMTextFieldCellOuterShadowBlurRadius * scaleFactor, kCDMTextFieldCellOuterShadowBlurRadius * scaleFactor);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:drawingRect xRadius:kCDMTextFieldCellCornerRadius yRadius:kCDMTextFieldCellCornerRadius];
    [firstResponder ? [NSColor cheddarOrangeColor] : [NSColor cheddarSteelColor] setStroke];
    [kCDMTextFieldCellFillColor setFill];
    [NSGraphicsContext saveGraphicsState];
    if (firstResponder) {
        NSShadow *outerShadow = [NSShadow new];
        [outerShadow setShadowBlurRadius:kCDMTextFieldCellOuterShadowBlurRadius * scaleFactor];
        [outerShadow setShadowColor:kCDMTextFieldCellOuterShadowColor];
        [outerShadow set];
    }
    [path setLineWidth:scaleFactor];
    [path stroke];
    [path fill];
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowBlurRadius:kCDMTextFieldCellInnerShadowBlurRadius * scaleFactor];
    [shadow setShadowColor:kCDMTextFieldCellInnerShadowColor];
    NSBezierPath *shadowPath = [NSBezierPath bezierPathWithRect:drawingRect];
    [path addClip];
    [shadowPath fillWithInnerShadow:shadow];
    [NSGraphicsContext restoreGraphicsState];
    [super drawInteriorWithFrame:[self adjustedFrameToVerticallyCenterText:cellFrame] inView:controlView];
}
@end
