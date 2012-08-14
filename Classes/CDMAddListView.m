//
//  CDMAddListView.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMAddListView.h"

#define CDMAddListViewSeparatorColor [NSColor colorWithCalibratedWhite:0.926 alpha:1.000]

@implementation CDMAddListView

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor whiteColor] set];
    NSRectFill([self bounds]);
    NSRect separatorRect = NSMakeRect(0.f, 0.f, [self bounds].size.width, 1.f);
    [CDMAddListViewSeparatorColor set];
    NSRectFill(separatorRect);
}

@end
