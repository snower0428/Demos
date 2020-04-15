//
//  NSData+Extend.h
//  AFNetworkingDemo
//
//  Created by leihui on 2019/9/30.
//  Copyright © 2019 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData(Extend)

/**
 NSData转化成string
 @return 返回nil的解决方案
 */
-(NSString *)convertedToUtf8String;

@end

NS_ASSUME_NONNULL_END
