//
//  NSImage+CDMAdditions.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "NSImage+CDMAdditions.h"

@implementation NSImage (CDMAdditions)

- (void)drawStretchableImageInRect:(CGRect)rect leftCapWidth:(CGFloat)leftCapWith {
	NSCompositingOperation operation = NSCompositeSourceOver;
	CGFloat fraction = 1.0f;
	
	CGSize sourceSize = self.size;
	CGSize destinationSize = rect.size;
	
	// Left cap
	CGRect sourceLeft = CGRectMake(0.0f, 0.0f, leftCapWith, sourceSize.height);
	CGRect destinationLeft = CGRectMake(0.0f, 0.0f, leftCapWith, destinationSize.height);
	[self drawInRect:destinationLeft fromRect:sourceLeft operation:operation fraction:fraction];
	
	// Center
	CGRect sourceCenter = CGRectMake(leftCapWith, 0.0f, sourceSize.width - leftCapWith - leftCapWith, sourceSize.height);
	CGRect destinationCenter = CGRectMake(leftCapWith, 0.0f, destinationSize.width - leftCapWith - leftCapWith, destinationSize.height);
	[self drawInRect:destinationCenter fromRect:sourceCenter operation:operation fraction:fraction];
	
	// Right cap
	CGRect sourceRight = CGRectMake(sourceSize.width - leftCapWith, 0.0f, leftCapWith, sourceSize.height);
	CGRect destinationRight = CGRectMake(destinationSize.width - leftCapWith, 0.0f, leftCapWith, destinationSize.height);
	[self drawInRect:destinationRight fromRect:sourceRight operation:operation fraction:fraction];
}


@end
