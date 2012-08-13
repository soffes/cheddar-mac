//
//  CDMListsWindowController.m
//  Cheddar
//
//  Created by Sam Soffes on 6/15/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMListsWindowController.h"
#import "CDMListTableRowView.h"
#import "CDMTaskTableRowView.h"
#import "CDMListTableCellView.h"
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
	
//	self.listsTableView.backgroundColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"arches"]];
//	self.tasksTableView.backgroundColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"arches"]];
}


#pragma mark - NSTableViewDelegate

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)rowIndex {
	if (tableView == self.listsTableView) {
		CDKList *list = [[self.listsArrayController arrangedObjects] objectAtIndex:rowIndex];
		[[CDKHTTPClient sharedClient] getTasksWithList:list success:^(AFJSONRequestOperation *operation, id responseObject) {
			[self.tasksArrayController fetch:nil];
		} failure:nil];
		self.tasksArrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"list = %@ AND archivedAt = nil", list];
		[self.tasksArrayController fetch:nil];
	}
	return YES;
}


- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
	if (tableView == self.listsTableView) {
		return [[CDMListTableRowView alloc] initWithFrame:CGRectZero];
	} else if (tableView == self.tasksTableView) {
		return [[CDMTaskTableRowView alloc] initWithFrame:CGRectZero];
	}
	return nil;
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	if (tableView == self.listsTableView) {
		return 45.0f;
	} else if (tableView == self.tasksTableView) {
		return 38.0f;
	}
	return 0.0f;
}

@end
