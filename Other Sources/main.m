//
//  main.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 6/14/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSTextView+CDMAdditions.h"

int main(int argc, char *argv[])
{
    [NSTextView swizzle];
	return NSApplicationMain(argc, (const char **)argv);
}
