//
//  DataItem.m
//  CoreAnimationDemo
//
//  Created by leihui on 17/3/31.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "DataItem.h"

#pragma mark - PointItem

@implementation PointItem

@end

#pragma mark - RectItem

@implementation RectItem

@end

#pragma mark - CircleItem

@implementation CircleItem

@end

#pragma mark - PathItem

@implementation PathItem

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
	return @{@"point": PointItem.class};
}

@end

#pragma mark - PartItem

@implementation PartItem

@end


#pragma mark - FrameItem

@implementation FrameItem

@end

#pragma mark - FillItem

@implementation FillItem

@end

#pragma mark - MarginItem

@implementation MarginItem

@end

#pragma mark - ImageItem

@implementation ImageItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
	return @{@"imageId": @"id"};
}

@end

#pragma mark - ColorItem

@implementation ColorItem

@end

#pragma mark - FontItem

@implementation FontItem

@end

#pragma mark - TextItem

@implementation TextItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
	return @{@"textId": @"id"};
}

@end

#pragma mark - DataItem

@implementation DataItem

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
	return @{@"part": PartItem.class,
			 @"text": TextItem.class,};
}

@end
