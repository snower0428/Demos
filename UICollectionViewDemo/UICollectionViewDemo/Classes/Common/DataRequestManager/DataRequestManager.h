//
//  DataRequestManager.h
//  DIYCollage
//
//  Created by leihui on 17/3/20.
//  Copyright © 2017年 Felink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataRequestDefines.h"

typedef void(^successful) (id responseObject);
typedef void(^failed) (NSError *error);

@interface DataRequestManager : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(DataRequestManager);

/**
 *	type: 80007-请求首页拼图数据类型，80008-请求拼图背影数据
 *	pageIndex: 请求页面索引，从1开始
 *	pageSize: 页面大小
 *	webp: 是否支持webp，1-支持，0-不支持
 *	successful: 成功
 *	failed: 失败
 */
- (void)requestDataWithResType:(NSInteger)type
					 pageIndex:(NSInteger)pageIndex
					  pageSize:(NSInteger)pageSize
						  webp:(NSInteger)webp
					successful:(successful)successful
						failed:(failed)failed;

/**
 *	请求全局参数
 *	successful: 成功
 *	failed: 失败
 */
- (void)requestGlobalData:(successful)successful failed:(failed)failed;

@end
