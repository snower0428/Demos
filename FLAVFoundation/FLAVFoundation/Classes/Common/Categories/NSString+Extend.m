//
//  NSString+Extend.m
//  FLAVFoundation
//
//  Created by leihui on 17/3/14.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "NSString+Extend.h"

@implementation NSString(Extend)

+ (BOOL)isEmptyString:(NSString *)string
{
	BOOL empty = YES;
	if (string) {
		NSString *tmp = [string stringByTrimmingwhitespaceAndNewlineCharacterSet];
		if (tmp && tmp.length>0) {
			empty = NO;
		}
	}
	return empty;
}

- (NSString *)stringByTrimmingwhitespaceAndNewlineCharacterSet
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
