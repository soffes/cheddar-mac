//
//  CDMTaskTableCellView.m
//  Cheddar for Mac
//
//  Created by Sam Soffes on 8/3/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDMTaskTableCellView.h"
#import "CDKTask+CDMAdditions.h"

@implementation CDMTaskTableCellView
@synthesize checkbox = _checkbox;

- (void)awakeFromNib {
	[super awakeFromNib];
    [self addObserver:self forKeyPath:@"objectValue.entities" options:0 context:NULL];
    [self addObserver:self forKeyPath:@"objectValue.completedAt" options:0 context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CDKTask *task = [self objectValue];
    [self.textField setAttributedStringValue:[task attributedDisplayText]];
    if ([keyPath isEqualToString:@"objectValue.completedAt"]) {
        [self.checkbox setState:[[self objectValue] isCompleted]];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"objectValue.entities"];
    [self removeObserver:self forKeyPath:@"objectValue.completedAt"];
}

#pragma mark - Mouse Events

- (void)mouseEntered:(NSEvent *)theEvent {
    [self.reorderView setAlphaValue:0.f];
    [self.reorderView setHidden:NO];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:kCDMTableViewAnimationDuration];
    [[self.reorderView animator] setAlphaValue:1.f];
    [NSAnimationContext endGrouping];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [self.reorderView setHidden:YES];
    }];
    [[NSAnimationContext currentContext] setDuration:kCDMTableViewAnimationDuration];
    [[self.reorderView animator] setAlphaValue:0.f];
    [NSAnimationContext endGrouping];
}
@end
