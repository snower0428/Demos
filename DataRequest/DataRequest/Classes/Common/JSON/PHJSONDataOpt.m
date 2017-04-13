//
//  PHJSONDataOpt.m
//  PHJSONDataOpt
//
//  Created by humin on 11-12-21.
//  Copyright 2011 nd.com.cn. All rights reserved.
//

#import "PHJSONDataOpt.h"
#import "JSON.h"
#import "PHGzipUtility.h"

@implementation PHJSONDataOpt

//上传NSData数据
+ (NSData *)getPostConfigData:(NSDictionary *)obj
{
	SBJSON *json = [SBJSON new];
	NSString *repString = [json stringWithObject:obj];
	NSData *data = [repString dataUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
	NSLog(@"json data:%@",repString);
#pragma clang diagnostic pop
	return [PHGzipUtility gzipData:data];
}

//上传NSData数据
+ (NSString *)getPostConfigString:(NSDictionary *)obj
{
	SBJSON *json = [SBJSON new];
	NSString *repString = [json stringWithObject:obj];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
	NSLog(@"json data:%@",repString);
#pragma clang diagnostic pop
	return repString;
}

//上传非压缩数据
+ (NSData *)getPostNormalConfigData:(NSDictionary *)obj
{
	SBJSON *json = [SBJSON new];
	NSString *repString = [json stringWithObject:obj];
	NSData *data = [repString dataUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"json data:%@",repString);
	return data;
}

/*
 解析服务器下发数据
 gzip--》JSON--》数据
 */
+ (id)parserjSONDataFromSvrEncodeByUTF8:(id)obj
{
	id data = nil;
	if ([obj isKindOfClass:[NSData class]]) 
	{
		//服务器端自动解压
		NSString *jsonrep = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
        data = [jsonrep JSONValue];
	}
	return data;
}

+ (id)parserjSONDataFromSvrEncodeByGBK:(id)obj
{
	id data = nil;
	if ([obj isKindOfClass:[NSData class]]) 
	{
		NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000); 
		NSString*jsonrep = [[NSString alloc] initWithData:obj encoding:gbkEncoding];
        data = [jsonrep JSONValue];
	}
	return data;
}

@end
