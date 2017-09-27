//
//  PasterItem.h
//  UIKitDemo
//
//  Created by leihui on 2017/6/1.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserItem : NSObject

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *in_name;

@end

@interface PasterItem : NSObject

@property (nonatomic, assign) NSInteger resId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger cate_id;
@property (nonatomic, assign) NSInteger man_cate_id;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *sample_url;
@property (nonatomic, assign) BOOL is_locked;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, assign) BOOL is_new;
@property (nonatomic, strong) NSString *thumb_url;
@property (nonatomic, assign) BOOL is_favorite;
@property (nonatomic, assign) NSInteger series_id;
@property (nonatomic, strong) NSString *series_name;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger level_id;
@property (nonatomic, strong) NSString *keyword;

@property (nonatomic, strong) UserItem *user;

@end

@interface PasterPackItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger bag_id;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSString *color;

@end

@interface CategoryItem : NSObject

@property (nonatomic, assign) NSInteger resId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger new_sort;
@property (nonatomic, assign) BOOL is_new;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, strong) NSArray *paster;
@property (nonatomic, assign) NSInteger next;
@property (nonatomic, assign) NSInteger page;

@end

@interface MainItem : NSObject

@property (nonatomic, assign) NSInteger resId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger new_sort;
@property (nonatomic, assign) BOOL is_new;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) BOOL more;

@end
