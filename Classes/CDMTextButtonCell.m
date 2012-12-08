//
//  CDMTextButtonCell.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTextButtonCell.h"
#import "NSColor+CDMAdditions.h"

#define CDMTextButtonCellFont [NSFont fontWithName:kCDMRegularFontName size:14.0]
#define CDMTextButtonCellNormalColor [NSColor cheddarSteelColor]
#define CDMTextButtonCellPressedColor [NSColor colorWithDeviceWhite:0.267f alpha:1.f]

@implementation CDMTextButtonCell

#pragma mark - NSCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSColor *color = [self isHighlighted] ? CDMTextButtonCellPressedColor : CDMTextButtonCellNormalColor;
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    [style setAlignment:NSCenterTextAlignment];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, CDMTextButtonCellFont, NSFontAttributeName, nil];
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:[self title] attributes:attributes];
    NSSize titleSize = [attrTitle size];
    NSRect titleRect = NSMakeRect(0.f, NSMidY(cellFrame) - (titleSize.height / 2.f), cellFrame.size.width, titleSize.height);
    [attrTitle drawInRect:NSIntegralRect(titleRect)];
}

@end
