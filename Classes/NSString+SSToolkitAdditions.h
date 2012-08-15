//
//  NSString+SSToolkitAdditions.h
//  Cheddar for Mac
//
//  Created by Indragie Karunaratne on 2012-08-15.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SSToolkitAdditions)
- (NSString *)stringByEscapingForURLQuery;
- (NSString *)stringByUnescapingFromURLQuery;
@end
