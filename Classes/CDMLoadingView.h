//
//  CDMLoadingView.h
//  Cheddar for Mac
//
//  Created by Sam Soffes on 12/9/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMColorView.h"

@interface CDMLoadingView : CDMColorView

@property (nonatomic, strong, readonly) NSTextField *textLabel;
@property (nonatomic, strong, readonly) NSProgressIndicator *activityIndicatorView;

@end
