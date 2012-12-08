//
//  CDMSecureTextField.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMSecureTextField.h"
#import "CDMSecureTextFieldCell.h"

@interface CDMSecureTextField ()
- (void)_redrawView;
@end

@implementation CDMSecureTextField

#pragma mark - NSObject

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(_redrawView) name:NSWindowDidBecomeKeyNotification object:[self window]];
        [nc addObserver:self selector:@selector(_redrawView) name:NSWindowDidResignKeyNotification object:[self window]];
        CDMSecureTextFieldCell *cell = [[CDMSecureTextFieldCell alloc] initTextCell:[self stringValue]];
        [cell setTarget:[self target]];
        [cell setAction:[self action]];
        [self setCell:cell];
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - NSControl

+ (Class)cellClass {
    return [CDMSecureTextFieldCell class];
}


#pragma mark - Private

- (void)_redrawView {
    [self setNeedsDisplay:YES];
}

@end
