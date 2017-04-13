//
//  Base64.h
//  GetUDID
//
//  Created by humin on 11-10-14.
//  Copyright 2011 nd.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Base64 : NSObject {

}

/*
 字符串加密\解密
 优先选取该项
 */
+ (NSString * )encodeBase64:(NSString * )input;
+ (NSString * )decodeBase64:(NSString * )input;

/*
 字符串加密\解密
 */
+ (NSString * )encodeBytes:(void *)pData len:(NSUInteger)length;
+ (const void * )decodeBytes:(NSString * )input;

+(NSString *)stringByEncodingData:(NSData *)data;
+(NSData *)decodeString:(NSString *)string;

@end
