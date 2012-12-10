//
//  CDMTasksPlaceholderView.h
//  Cheddar for Mac
//
//  Created by Sam Soffes on 12/9/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMColorView.h"

@interface CDMTasksPlaceholderView : CDMColorView

@property (weak) IBOutlet NSTextField *addLabel;
@property (weak) IBOutlet NSImageView *iconImageView;
@property (weak) IBOutlet NSTextField *titleLabel;

@end
