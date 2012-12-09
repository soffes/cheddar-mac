//
//  NSView+CDMAdditions.h
//  Cheddar for Mac
//
//  Created by Sam Soffes on 12/9/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

NS_OPTIONS(NSUInteger, NSViewAutoresizing) {
    NSViewAutoresizingNone                 = NSViewNotSizable,
    NSViewAutoresizingFlexibleLeftMargin   = NSViewMinXMargin,
    NSViewAutoresizingFlexibleWidth        = NSViewWidthSizable,
    NSViewAutoresizingFlexibleRightMargin  = NSViewMaxXMargin,
    NSViewAutoresizingFlexibleTopMargin    = NSViewMaxYMargin,
    NSViewAutoresizingFlexibleHeight       = NSViewHeightSizable,
    NSViewAutoresizingFlexibleBottomMargin = NSViewMinYMargin
};
