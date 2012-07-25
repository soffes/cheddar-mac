//
//  CDMListsWindowController.m
//  Cheddar
//
//  Created by Sam Soffes on 6/15/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMListsWindowController.h"
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
	
	INAppStoreWindow *aWindow = (INAppStoreWindow *)self.window;
	aWindow.titleBarHeight = 60.0f;
	[aWindow setTitleBarDrawingBlock:^(BOOL drawsAsMainWindow, CGRect drawingRect, CGPathRef clippingPath){
		CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
		CGContextSaveGState(context);
		CGContextAddPath(context, clippingPath);
		CGContextClip(context);
		
		// Top inset
		[[NSColor colorWithCalibratedRed:0.973f green:0.647f blue:0.545f alpha:1.0f] setFill];
		CGRect rect = drawingRect;
		rect.origin.y = rect.size.height - 1.0f;
		rect.size.height = 1.0f;
		CGContextFillRect(context, rect);
		
		// Bottom inset
		[[NSColor colorWithCalibratedRed:0.988f green:0.553f blue:0.427f alpha:1.0f] setFill];
		rect.origin.y = 1.0f;
		CGContextFillRect(context, rect);

		// Bottom border
		[[NSColor colorWithCalibratedRed:0.737f green:0.282f blue:0.165f alpha:1.0f] setFill];
		rect.origin.y = 0.0f;
		CGContextFillRect(context, rect);
		
		// Gradient
		rect = drawingRect;
		rect.origin.y += 2.0f;
		rect.size.height -= 3.0f;
		NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.969f green:0.549f blue:0.424f alpha:1.0f] endingColor:[NSColor colorWithCalibratedRed:0.992f green:0.451f blue:0.294f alpha:1.0f]];
		[gradient drawInRect:rect angle:-90.0f];
				
		NSImage *image = [NSImage imageNamed:@"title.png"];
		rect = CGRectMake(roundf((drawingRect.size.width - 135.0f) / 2.0f), roundf((drawingRect.size.height - 24.0f) / 2.0f) - 2.0f, 135.0f, 24.0f);
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

@end
