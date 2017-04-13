//
//  DemoItem.m
//  UICollectionViewDemo
//
//  Created by leihui on 17/3/22.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "DemoItem.h"

@implementation DemoItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
	return @{@"resId": @"ResId",
			 @"name": @"Name",
			 @"icon": @"Icon",
			 @"iconSmallUrl": @"IconSmallUrl",
			 @"previewUrl": @"PreviewUrl",
			 @"downloadUrl": @"DownloadUrl",
			 @"size": @"Size",};
}

@end
