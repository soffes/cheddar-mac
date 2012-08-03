//
//  NSImage+CDMAdditions.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "NSImage+CDMAdditions.h"

@implementation NSImage (CDMAdditions)

- (void)drawStretchableInRect:(NSRect)rect edgeInsets:(NSEdgeInsets)insets operation:(NSCompositingOperation)op fraction:(CGFloat)delta {
	void (^makeAreas)(NSRect, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *) = ^(NSRect srcRect, NSRect *tl, NSRect *tc, NSRect *tr, NSRect *ml, NSRect *mc, NSRect *mr, NSRect *bl, NSRect *bc, NSRect *br) {
		CGFloat w = NSWidth(srcRect);
		CGFloat h = NSHeight(srcRect);
		CGFloat cw = w - insets.left - insets.right;
		CGFloat ch = h - insets.top - insets.bottom;
		
		CGFloat x0 = NSMinX(srcRect);
		CGFloat x1 = x0 + insets.left;
		CGFloat x2 = NSMaxX(srcRect) - insets.right;
		
		CGFloat y0 = NSMinY(srcRect);
		CGFloat y1 = y0 + insets.bottom;
		CGFloat y2 = NSMaxY(srcRect) - insets.top;
		
		*tl = NSMakeRect(x0, y2, insets.left, insets.top);
		*tc = NSMakeRect(x1, y2, cw, insets.top);
		*tr = NSMakeRect(x2, y2, insets.right, insets.top);
		
		*ml = NSMakeRect(x0, y1, insets.left, ch);
		*mc = NSMakeRect(x1, y1, cw, ch);
		*mr = NSMakeRect(x2, y1, insets.right, ch);
		
		*bl = NSMakeRect(x0, y0, insets.left, insets.bottom);
		*bc = NSMakeRect(x1, y0, cw, insets.bottom);
		*br = NSMakeRect(x2, y0, insets.right, insets.bottom);
	};
	
	// Source rects
	NSRect srcRect = (NSRect){NSZeroPoint, self.size};
	NSRect srcTopL, srcTopC, srcTopR, srcMidL, srcMidC, srcMidR, srcBotL, srcBotC, srcBotR;
	makeAreas(srcRect, &srcTopL, &srcTopC, &srcTopR, &srcMidL, &srcMidC, &srcMidR, &srcBotL, &srcBotC, &srcBotR);
	
	// Destinations rects
	NSRect dstTopL, dstTopC, dstTopR, dstMidL, dstMidC, dstMidR, dstBotL, dstBotC, dstBotR;
	makeAreas(rect, &dstTopL, &dstTopC, &dstTopR, &dstMidL, &dstMidC, &dstMidR, &dstBotL, &dstBotC, &dstBotR);
	
	// Draw
	[self drawInRect:dstTopL fromRect:srcTopL operation:op fraction:delta];
	[self drawInRect:dstTopC fromRect:srcTopC operation:op fraction:delta];
	[self drawInRect:dstTopR fromRect:srcTopR operation:op fraction:delta];
	
	[self drawInRect:dstMidL fromRect:srcMidL operation:op fraction:delta];
	[self drawInRect:dstMidC fromRect:srcMidC operation:op fraction:delta];
	[self drawInRect:dstMidR fromRect:srcMidR operation:op fraction:delta];
	
	[self drawInRect:dstBotL fromRect:srcBotL operation:op fraction:delta];
	[self drawInRect:dstBotC fromRect:srcBotC operation:op fraction:delta];
	[self drawInRect:dstBotR fromRect:srcBotR operation:op fraction:delta];
}

@end
