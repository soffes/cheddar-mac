//
//  NSImage+CDMAdditions.h
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface NSImage (CDMAdditions)

- (void)drawStretchableInRect:(NSRect)rect edgeInsets:(NSEdgeInsets)insets operation:(NSCompositingOperation)op fraction:(CGFloat)delta;

@end
