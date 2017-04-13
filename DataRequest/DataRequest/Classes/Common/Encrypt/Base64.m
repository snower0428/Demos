//
//  Base64.m
//  GetUDID
//
//  Created by humin on 11-10-14.
//  Copyright 2011 nd.com.cn. All rights reserved.
//

#import "Base64.h"
#import "GTMBase64.h"

@implementation Base64

+ (NSString * )encodeBase64:(NSString * )input 
{ 
    NSData * data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
    data = [GTMBase64 encodeData:data]; 
    NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
	return base64String; 
}

+ (NSString * )decodeBase64:(NSString * )input 
{ 
    NSData * data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
    data = [GTMBase64 decodeData:data]; 
    NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
	return base64String; 
}

+ (NSString * )encodeBytes:(void *)pData len:(NSUInteger)length
{
	NSData * data = nil;
#if 1
	data = [GTMBase64 encodeBytes:pData length:length];
#else
	data = [GTMBase64 encodeData:[NSData dataWithBytes:pData length:length]]; 
#endif
	NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
	return base64String;
}

+ (const void * )decodeBytes:(NSString * )input 
{ 
	NSData * data = nil;
#if 0
	data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
	data = [GTMBase64 decodeData:data];
#else
	data = [GTMBase64 decodeBytes:[input UTF8String] length:[input length]];
#endif
	return data.bytes; 
}

+(NSString *)stringByEncodingData:(NSData *)data
{
	return [GTMBase64 stringByEncodingData:data];
}

+(NSData *)decodeString:(NSString *)string
{
	return [GTMBase64 decodeString:string];
}

@end
