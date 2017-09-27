//
//  PasterItem.m
//  UIKitDemo
//
//  Created by leihui on 2017/6/1.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "PasterItem.h"

@implementation UserItem

@end

@implementation PasterItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
	return @{@"resId": @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
	return @{@"user": UserItem.class};
}

@end

@implementation PasterPackItem

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
	return @{@"list": PasterItem.class};
}

@end

@implementation CategoryItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
	return @{@"resId": @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
	return @{@"paster": PasterItem.class};
}

@end

@implementation MainItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
	return @{@"resId": @"id"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
	return @{@"data": CategoryItem.class};
}

@end
