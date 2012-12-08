//
//  CDMTagFilterBar.h
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-15.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@protocol CDMTagFilterBarDelegate;

@interface CDMTagFilterBar : NSView

@property (nonatomic, assign) IBOutlet id<CDMTagFilterBarDelegate> delegate;

@end


@protocol CDMTagFilterBarDelegate <NSObject>

@optional

- (void)tagFilterBarClicked:(CDMTagFilterBar *)bar;

@end
