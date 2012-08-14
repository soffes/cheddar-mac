//
//  CDMTextFieldCell.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTextFieldCell.h"
#import "NSBezierPath+MCAdditions.h"
#import "NSColor+CDMAdditions.h"
#import "NSView+CDMAdditions.h"

static CGFloat const kCDMTextFieldCellXInset = 15.0f;
static CGFloat const kCDMTextFieldCellCornerRadius = 4.0f;
static CGFloat const kCDMTextFieldCellInnerShadowBlurRadius = 2.0f;
static CGFloat const kCDMTextFieldCellOuterShadowBlurRadius = 2.0f;
#define kCDMTextFieldCellInnerShadowColor [NSColor colorWithDeviceWhite:0.0 alpha:0.2f]
#define kCDMTextFieldCellOuterShadowColor [[NSColor cheddarOrangeColor] colorWithAlphaComponent:0.5f]
#define kCDMTextFieldCellFillColor [NSColor whiteColor]

@implementation CDMTextFieldCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.font = [NSFont fontWithName:kCDMRegularFontName size:14.0];
        self.textColor = [NSColor colorWithCalibratedRed:0.200 green:0.200 blue:0.200 alpha:1];
        [self setDrawsBackground:NO];
        [self setBordered:NO];
        [self setBezeled:NO];
        [self setFocusRingType:NSFocusRingTypeNone];
        [self setEditable:YES];
    }
    return self;
}


- (void)setPlaceholderString:(NSString *)string {
	NSDictionary *placeholderAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
										   [NSColor cheddarSteelColor], NSForegroundColorAttributeName,
										   nil];
	NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:string attributes:placeholderAttributes];
	[self setPlaceholderAttributedString:placeholder];
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


- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    CGFloat scaleFactor = [[controlView window] backingScaleFactor];
    BOOL firstResponder = [controlView isFirstResponder];

	CGFloat inset = (kCDMTextFieldCellOuterShadowBlurRadius + 1.0f) * scaleFactor;
    NSRect drawingRect = NSInsetRect(cellFrame, inset, inset);
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
	
    [path setLineWidth:2.0];
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
