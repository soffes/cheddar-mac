//
//  CDMTaskTextField.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTaskTextField.h"

@implementation CDMTaskTextField

- (void)mouseDragged:(NSEvent *)theEvent
{
    [super mouseDragged:theEvent];
    NSLog(@"dragged");
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"mouse down");
    [super mouseDown:theEvent];
}
@end
