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
#define CDMTagFilterBarInactiveTopColor [NSColor colorWithCalibratedRed:0.710 green:0.705 blue:0.710 alpha:1.000] 
#define CDMTagFilterBarInactiveBottomColor [NSColor colorWithCalibratedWhite:0.542 alpha:1.000]

@interface CDMTagFilterBar ()
- (void)_redrawView;
@end

@implementation CDMTagFilterBar
@synthesize delegate = _delegate;

- (id)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(_redrawView) name:NSWindowDidBecomeKeyNotification object:[self window]];
        [nc addObserver:self selector:@selector(_redrawView) name:NSWindowDidResignKeyNotification object:[self window]];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawRect:(NSRect)dirtyRect {
    BOOL active = [[self window] isKeyWindow] && [NSApp isActive];
    NSColor *topColor = active ? CDMTagFilterBarTopColor : CDMTagFilterBarInactiveTopColor;
    NSColor *bottomColor = active ? CDMTagFilterBarBottomColor : CDMTagFilterBarInactiveBottomColor;
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:bottomColor endingColor:topColor];
    [gradient drawInRect:[self bounds] angle:90.f];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if ([self.delegate respondsToSelector:@selector(tagFilterBarClicked:)]) {
        [self.delegate tagFilterBarClicked:self];
    }
}

#pragma mark - Private

- (void)_redrawView {
    [self setNeedsDisplay:YES];
}
@end
