//
//  LHAlertView.m
//  GCDDemo
//
//  Created by leihui on 2017/9/30.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "LHAlertView.h"
#import <objc/runtime.h>

static void *LHAlertViewKey = @"LHAlertViewKey";

@interface LHAlertView ()

@property (nonatomic, copy) AlertViewBlock block;

@end

@implementation LHAlertView

- (instancetype)initWithTitle:(NSString *)title
					  message:(NSString *)message
						block:(AlertViewBlock)block
			cancelButtonTitle:(NSString *)cancelButtonTitle
			otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
	if (self) {
		// Init
		_block = [block copy];
		objc_setAssociatedObject(self, LHAlertViewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
	}
	return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	AlertViewBlock block = objc_getAssociatedObject(self, LHAlertViewKey);
	if (block) {
		block(buttonIndex);
	}
}

@end
