//
//  CDMArchesWindow.h
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-13.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CDMArchesWindow : NSWindow
@property (nonatomic, assign) BOOL closeEnabled;
@property (nonatomic, assign) BOOL minimizeEnabled;
@property (nonatomic, assign) BOOL zoomEnabled;
@end

@interface CDMArchesWindowContentView : NSView
@end