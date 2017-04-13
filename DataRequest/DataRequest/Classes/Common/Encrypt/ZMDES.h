//
//  ZMDES.h
//  BZUtility
//
//  Created by LinXiaoBin on 15/7/15.
//  Copyright (c) 2015年 Orion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMDES : NSObject


+ (NSData *)zmDESEncrypt:(NSData *)data WithKey:(NSString *)key;

+ (NSData *)zmDESDecrypt:(NSData *)data WithKey:(NSString *)key;


/**
 *  @brief  文本数据进行DES加密，此函数不可用于过长文本
 *
 *  @param data 需要加密的数据
 *  @param key  密钥
 *
 *  @return 加密后的数据
 */
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;

/**
 *  @brief  文本数据进行DES解密，此函数不可用于过长文本
 *
 *  @param data 需要解密的数据
 *  @param key  密钥
 *
 *  @return 解密后的数据
 */
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;


/**
 *  @brief  文本数据进行3DES加密，此函数不可用于过长文本
 *
 *  @param data 需要加密的数据
 *  @param key  密钥
 *
 *  @return 加密后的数据
 */
+ (NSData *)ThreeDESEncrypt:(NSData *)data WithKey:(NSString *)key;

/**
 *  @brief  文本数据进行3DES解密，此函数不可用于过长文本
 *
 *  @param data 需要解密的数据
 *  @param key  密钥
 *
 *  @return 解密后的数据
 */
+ (NSData *)ThreeDESDecrypt:(NSData *)data WithKey:(NSString *)key;

@end
