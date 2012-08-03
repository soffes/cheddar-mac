//
//  CDMListsWindowController.m
//  Cheddar
//
//  Created by Sam Soffes on 6/15/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMListsWindowController.h"
#import "CDMListTableRowView.h"
#import "INAppStoreWindow.h"

void SSDrawGradientInRect(CGContextRef context, CGGradientRef gradient, CGRect rect) {
	CGContextSaveGState(context);
	CGContextClipToRect(context, rect);
	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
	CGContextDrawLinearGradient(context, gradient, start, end, 0);
	CGContextRestoreGState(context);
}


@implementation CDMListsWindowController

@synthesize listsArrayController = _listsArrayController;
@synthesize listsTableView = _listsTableView;
@synthesize tasksArrayController = _tasksArrayController;
@synthesize tasksTableView = _tasksTableView;


#pragma mark - NSWindowController

- (NSString *)windowNibName {
	return @"Lists";
}


- (void)windowDidLoad {
	[super windowDidLoad];
	
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
	
	INAppStoreWindow *aWindow = (INAppStoreWindow *)self.window;
	aWindow.titleBarHeight = 40.0f;
	[aWindow setTitleBarDrawingBlock:^(BOOL drawsAsMainWindow, CGRect drawingRect, CGPathRef clippingPath){
		CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
		CGContextSaveGState(context);
		CGContextAddPath(context, clippingPath);
		CGContextClip(context);
		
		// Top inset
		[[colorList colorWithKey:@"topInset"] setFill];
		CGRect rect = drawingRect;
		rect.origin.y = rect.size.height - 1.0f;
		rect.size.height = 1.0f;
		CGContextFillRect(context, rect);
		
		// Bottom inset
		[[colorList colorWithKey:@"bottomInset"] setFill];
		rect.origin.y = 1.0f;
		CGContextFillRect(context, rect);

		// Bottom border
		[[colorList colorWithKey:@"bottomBorder"] setFill];
		rect.origin.y = 0.0f;
		CGContextFillRect(context, rect);
		
		// Gradient
		rect = drawingRect;
		rect.origin.y += 2.0f;
		rect.size.height -= 3.0f;
		NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[colorList colorWithKey:@"gradientTop"] endingColor:[colorList colorWithKey:@"gradientBottom"]];
		[gradient drawInRect:rect angle:-90.0f];
				
		NSImage *image = [NSImage imageNamed:@"title"];
		rect = CGRectMake(roundf((drawingRect.size.width - 135.0f) / 2.0f), roundf((drawingRect.size.height - 24.0f) / 2.0f) + 1.0f, 135.0f, 24.0f);
		[image drawInRect:rect fromRect:CGRectZero operation:NSCompositeSourceOver fraction:1.0f];
		
		CGContextRestoreGState(context);
	}];
	
	self.listsArrayController.managedObjectContext = [CDKList mainContext];
	self.listsArrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"archivedAt = nil && user = %@", [CDKUser currentUser]];
	self.listsArrayController.sortDescriptors = [CDKList defaultSortDescriptors];
	
	self.tasksArrayController.managedObjectContext = [CDKTask mainContext];
	self.tasksArrayController.sortDescriptors = [CDKTask defaultSortDescriptors];
	
	[[CDKHTTPClient sharedClient] getListsWithSuccess:^(AFJSONRequestOperation *operation, id responseObject) {
		NSLog(@"Got lists");
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		NSLog(@"Failed to get lists: %@", error);
	}];
}


#pragma mark - NSTableViewDelegate

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
	if (aTableView == self.listsTableView) {
		CDKList *list = [[self.listsArrayController arrangedObjects] objectAtIndex:rowIndex];
		[[CDKHTTPClient sharedClient] getTasksWithList:list success:^(AFJSONRequestOperation *operation, id responseObject) {
			NSLog(@"Fetched %@ tasks", list.title);
			[self.tasksArrayController fetch:nil];
		} failure:nil];
		self.tasksArrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"list = %@ AND archivedAt = nil", list];
		[self.tasksArrayController fetch:nil];
	}
	
	return YES;
}


- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
	return [[CDMListTableRowView alloc] initWithFrame:CGRectZero];
}

@end
