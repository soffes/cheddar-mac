//
//  CDMPlusWindow.h
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-14.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CDMPlusWindow : NSWindow
@property (nonatomic, assign) NSWindow *parentWindow;
@end

@interface CDMPlusWindowContentView : NSView
@end