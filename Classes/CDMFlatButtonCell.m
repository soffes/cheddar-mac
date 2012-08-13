//
//  CDMFlatButtonCell.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMFlatButtonCell.h"

static CGFloat const CDMFlatButtonCellCornerRadius = 4.0f;
#define CDMFlatButtonCellTextFont [NSFont fontWithName:kCDMBoldFontName size:16.0]
#define CDMFlatButtonCellTextColor [NSColor whiteColor]
#define CDMFlatButtonCellOverlayColor [NSColor colorWithDeviceWhite:0.f alpha:0.2f]

@implementation CDMFlatButtonCell
@synthesize buttonColor = _buttonColor;

- (id)init
{
    if ((self = [super init])) {
        [self setBordered:NO];
    }
    return self;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:CDMFlatButtonCellCornerRadius yRadius:CDMFlatButtonCellCornerRadius];
    [self.buttonColor set];
    [path fill];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    [style setAlignment:NSCenterTextAlignment];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:style, NSParagraphStyleAttributeName, CDMFlatButtonCellTextColor, NSForegroundColorAttributeName, CDMFlatButtonCellTextFont, NSFontAttributeName, nil];
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:[self title] attributes:attributes];
    NSSize titleSize = [attrTitle size];
    NSRect titleRect = NSMakeRect(0.f, NSMidY(cellFrame) - (titleSize.height / 2.f) + 1.f, cellFrame.size.width, titleSize.height);
    [attrTitle drawInRect:NSIntegralRect(titleRect)];
    if ([self isHighlighted]) {
        [CDMFlatButtonCellOverlayColor set];
        [path fill];
    }
}
@end
