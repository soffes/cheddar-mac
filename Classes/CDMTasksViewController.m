//
//  CDMTasksViewController.m
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTasksViewController.h"
#import "CDMTaskTableRowView.h"

@interface CDMTasksViewController ()

@end

@implementation CDMTasksViewController
@synthesize arrayController = _arrayController;
@synthesize tableView = _tableView;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.arrayController.managedObjectContext = [CDKTask mainContext];
	self.arrayController.sortDescriptors = [CDKTask defaultSortDescriptors];
}

#pragma mark - Lists

- (void)selectList:(CDKList*)list
{
    [[CDKHTTPClient sharedClient] getTasksWithList:list success:^(AFJSONRequestOperation *operation, id responseObject) {
        [self.arrayController fetch:nil];
    } failure:nil];
    self.arrayController.fetchPredicate = [NSPredicate predicateWithFormat:@"list = %@ AND archivedAt = nil", list];
    [self.arrayController fetch:nil];
}

#pragma mark - NSTableViewDelegate

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
	return [[CDMTaskTableRowView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	return 38.0f;
}
@end
