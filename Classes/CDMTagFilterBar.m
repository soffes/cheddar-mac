//
//  CDMTagFilterBar.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-15.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTagFilterBar.h"

#define CDMTagFilterBarBottomColor [NSColor colorWithCalibratedRed:0.071 green:0.570 blue:0.801 alpha:1.000]
#define CDMTagFilterBarTopColor [NSColor colorWithCalibratedRed:0.082 green:0.654 blue:0.887 alpha:1.000]

@implementation CDMTagFilterBar

- (void)drawRect:(NSRect)dirtyRect
{
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:CDMTagFilterBarBottomColor endingColor:CDMTagFilterBarTopColor];
    [gradient drawInRect:[self bounds] angle:90.f];
}

@end
