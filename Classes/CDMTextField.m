//
//  CDMTextField.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTextField.h"

@interface CDMTextField ()
- (void)_redrawView;
@end

@implementation CDMTextField

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(_redrawView) name:NSWindowDidBecomeKeyNotification object:[self window]];
        [nc addObserver:self selector:@selector(_redrawView) name:NSWindowDidResignKeyNotification object:[self window]];
    }
    return self;
}

- (void)_redrawView {
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
