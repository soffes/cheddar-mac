//
//  CDMMainWindow.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/5/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMMainWindow.h"

static inline CGImageRef _createNoiseImageRef(NSUInteger width, NSUInteger height, CGFloat factor) {
    NSUInteger size = width * height;
    char *rgba = (char *)malloc(size);
	srand(124);
    for (NSUInteger i=0; i < size; ++i) {
		rgba[i] = rand() % 256 * factor;
	}
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapContext = CGBitmapContextCreate(rgba, width, height, 8, width, colorSpace, kCGImageAlphaNone);
    CGImageRef image = CGBitmapContextCreateImage(bitmapContext);
    CFRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    free(rgba);
    return image;
}


@implementation CDMMainWindow

- (void)awakeFromNib {
	[super awakeFromNib];
	
	NSColorList *colorList = [[NSColorList alloc] initWithName:NSStringFromClass([self class])];
	
	NSColorSpace *sRGB = [NSColorSpace sRGBColorSpace];
	
	CGFloat components[] = { 239.0 / 255.0, 157.0 / 255.0, 133.0 / 255.0, 1.0 };
	[colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"topInset"];
	
	components[0] = 1.0;
	components[1] = 136.0 / 255.0;
	components[2] = 96.0 / 255.0;
	[colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"bottomInset"];
	
	components[0] = 101.0 / 255.0;
	components[1] = 101.0 / 255.0;
	components[2] = 101.0 / 255.0;
	[colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"bottomBorder"];
	
	components[0] = 249.0 / 255.0;
	components[1] = 138.0 / 255.0;
	components[2] = 102.0 / 255.0;
	[colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"gradientTop"];
	
	components[0] = 1.0;
	components[1] = 112.0 / 255.0;
	components[2] = 63.0 / 255.0;
	[colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"gradientBottom"];
	
	[colorList setColor:[NSColor whiteColor] forKey:@"topInsetUnemphasized"];
	
	components[0] = 251.0 / 255.0;
	components[1] = 251.0 / 255.0;
	components[2] = 251.0 / 255.0;
	[colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"gradientTopUnemphasized"];
	
	components[0] = 223.0 / 255.0;
	components[1] = 223.0 / 255.0;
	components[2] = 223.0 / 255.0;
	[colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"gradientBottomUnemphasized"];
	
	components[0] = 228.0 / 255.0;
	components[1] = 228.0 / 255.0;
	components[2] = 228.0 / 255.0;
	[colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"bottomInsetUnemphasized"];
	
	components[0] = 166.0 / 255.0;
	components[1] = 166.0 / 255.0;
	components[2] = 166.0 / 255.0;
	[colorList setColor:[NSColor colorWithColorSpace:sRGB components:components count:4] forKey:@"bottomBorderUnemphasized"];
	
	
	self.titleBarHeight = 44.0f;
	self.centerFullScreenButton = YES;
	self.fullScreenButtonRightMargin = 10.0f;
	[self setTitleBarDrawingBlock:^(BOOL drawsAsMainWindow, CGRect drawingRect, CGPathRef clippingPath){
		CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
		CGContextSaveGState(context);
		CGContextAddPath(context, clippingPath);
		CGContextClip(context);
		
		NSColor *topInset = nil;
		NSColor *bottomInset = nil;
		NSColor *bottomBorder = nil;
		NSColor *gradientTop = nil;
		NSColor *gradientBottom = nil;
		
		if (drawsAsMainWindow) {
			topInset = [colorList colorWithKey:@"topInset"];
			bottomInset = [colorList colorWithKey:@"bottomInset"];
			bottomBorder = [colorList colorWithKey:@"bottomBorder"];
			gradientTop = [colorList colorWithKey:@"gradientTop"];
			gradientBottom = [colorList colorWithKey:@"gradientBottom"];
		} else {
			topInset = [colorList colorWithKey:@"topInsetUnemphasized"];
			bottomInset = [colorList colorWithKey:@"bottomInsetUnemphasized"];
			bottomBorder = [colorList colorWithKey:@"bottomBorderUnemphasized"];
			gradientTop = [colorList colorWithKey:@"gradientTopUnemphasized"];
			gradientBottom = [colorList colorWithKey:@"gradientBottomUnemphasized"];
		}
		
		// Top inset
		[topInset setFill];
		CGRect rect = drawingRect;
		rect.origin.y = rect.size.height - 1.0f;
		rect.size.height = 1.0f;
		CGContextFillRect(context, rect);
		
		// Bottom inset
		[bottomInset setFill];
		rect.origin.y = 1.0f;
		CGContextFillRect(context, rect);
		
		// Bottom border
		[bottomBorder setFill];
		rect.origin.y = 0.0f;
		CGContextFillRect(context, rect);
		
		// Gradient
		rect = drawingRect;
		rect.origin.y += 2.0f;
		rect.size.height -= 3.0f;
		NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:gradientTop endingColor:gradientBottom];
		[gradient drawInRect:rect angle:-90.0f];
		
		// Noise
//		if (drawsAsMainWindow) {
			static CGImageRef noisePattern = nil;
            if (noisePattern == nil) {
                noisePattern = _createNoiseImageRef(128, 128, 0.015);
            }
			      
            CGContextSetBlendMode(context, kCGBlendModePlusLighter);
            CGRect noisePatternRect = CGRectZero;
            noisePatternRect.size = CGSizeMake(CGImageGetWidth(noisePattern), CGImageGetHeight(noisePattern));
            CGContextDrawTiledImage(context, noisePatternRect, noisePattern);
//		}
		
		// Title
		NSImage *image = [NSImage imageNamed:@"title"];
		rect = CGRectMake(roundf((drawingRect.size.width - 135.0f) / 2.0f), roundf((drawingRect.size.height - 24.0f) / 2.0f) + 1.0f, 135.0f, 24.0f);
		[image drawInRect:rect fromRect:CGRectZero operation:NSCompositeSourceOver fraction:1.0f];
		
		CGContextRestoreGState(context);
	}];
}

@end
