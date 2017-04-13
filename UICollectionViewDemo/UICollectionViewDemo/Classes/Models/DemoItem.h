//
//  DemoItem.h
//  UICollectionViewDemo
//
//  Created by leihui on 17/3/22.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface DemoItem : NSObject

@property (nonatomic, strong) NSString *resId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *iconSmallUrl;
@property (nonatomic, strong) NSString *previewUrl;
@property (nonatomic, strong) NSString *downloadUrl;
@property (nonatomic, strong) NSString *size;

@end
