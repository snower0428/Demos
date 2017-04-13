//
//  DataRequestManager.m
//  DIYCollage
//
//  Created by leihui on 17/3/20.
//  Copyright © 2017年 Felink. All rights reserved.
//

#import "DataRequestManager.h"
#import <AFNetworking/AFNetworking.h>
#import <FLEncrypt/FLEncrypt.h>
#import <ZMDuid/ZMDuid.h>

#define  kServeRequestMagicCode     @"8127B1FF-DD18-49F8-D48B-6928FB6E2928"

#define  kHeaderPIDKey              @"PID"
#define  kHeaderMTKey               @"MT"
#define  kHeaderDivideVersionKey    @"DivideVersion"
#define  kHeaderSupPhoneKey         @"SupPhone"
#define  kHeaderSupFirmKey          @"SupFirm"
#define  kHeaderIMEIKey             @"IMEI"
#define  kHeaderIMSIKey             @"IMSI"
#define  kHeaderProtocolVersionKey  @"ProtocolVersion"
#define  kHeaderSignKey             @"Sign"

#define	kProductID					@"226"

@implementation DataRequestManager

SYNTHESIZE_SINGLETON_FOR_CLASS(DataRequestManager);

- (void)requestDataWithResType:(NSInteger)type
					 pageIndex:(NSInteger)pageIndex
					  pageSize:(NSInteger)pageSize
						  webp:(NSInteger)webp
					successful:(successful)successful
						failed:(failed)failed
{
	NSString *strUrl = [kThemeActionUrl stringByAppendingString:@"2014"];
	
	NSDictionary *params = [self paramsWithResType:type pageIndex:pageIndex pageSize:pageSize webp:webp];
	NSDictionary *header = [self headerWithParams:params];
	NSData *content = nil;
	BOOL isValid = [NSJSONSerialization isValidJSONObject:params];
	if (isValid) {
		content = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
	}
	[self requestWithUrl:strUrl header:header content:content successful:successful failed:failed];
}

- (void)requestGlobalData:(successful)successful failed:(failed)failed
{
	NSString *pid = kProductID;
	NSString *mt = @"1";
	
	NSString *supPhone = [BZDeviceInfo platform];
	NSString *supFirm = [BZDeviceInfo osVersion];
	NSString *supFun = [BZDeviceInfo appVersion];
	NSString *udid = [ZMDuid duid];
	
	NSString *action = @"1001";
	
	NSString *strUrl = [NSString stringWithFormat:@"%@mt=%@&pid=%@&SupPhone=%@&SupFirm=%@&SupFun=%@&DivideVersion=%@&udid=%@&imei=%@&action=%@",
						kGlobalParamUrl, mt, pid, supPhone, supFirm, supFun, supFun, udid, udid, action];
	
	[self requestWithUrl:strUrl header:nil content:nil successful:successful failed:failed];
}

#pragma mark - Private

- (void)requestWithUrl:(NSString *)strUrl header:(NSDictionary *)header content:(NSData *)conent successful:(successful)successful failed:(failed)failed
{
	NSURL *requestUrl = [NSURL URLWithString:strUrl];
	if (requestUrl) {
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
		request.HTTPMethod = @"POST";
		if (header) {
			[header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
				[request setValue:obj forHTTPHeaderField:key];
			}];
		}
		if (conent) {
			request.HTTPBody = conent;
		}
		
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
		manager.responseSerializer = [AFHTTPResponseSerializer serializer];
		
		NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
			NSLog(@"");
			NSDictionary *header = nil;
			if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
				header = [(NSHTTPURLResponse *)response allHeaderFields];
			}
			
			if (!error) {
				// Successful
				if (responseObject == nil) {
					if ([header[@"ResultCode"] integerValue] == 0) {
						NSLog(@"服务器没有返回数据");
					}
					else {
						NSLog(@"连接网络失败");
					}
				}
				else {
					BOOL bError = YES;
					
					if (responseObject != nil) {
						id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
						if (obj && [obj isKindOfClass:[NSDictionary class]]) {
							bError = NO;
							successful(obj);
						}
						else if (obj && [obj isKindOfClass:[NSArray class]]) {
							bError = NO;
							successful(obj);
						}
					}
					else {
						bError = YES;
					}
					
					if (bError) {
						NSLog(@"数据解析失败");
						failed(error);
					}
				}
			}
			else {
				// Failed
				NSLog(@"afRequestFailed:%@", @(error.code));
				failed(error);
			}
		}];
		[task resume];
	}
}

- (NSDictionary *)paramsWithResType:(NSInteger)type pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize webp:(NSInteger)webp
{
	NSDictionary *params = @{@"typeid": @(type),
							 @"pageindex": @(pageIndex),
							 @"pagesize": @(pageSize),
							 @"GetWebp": @(webp),};
	return params;
}

- (NSDictionary *)headerWithParams:(NSDictionary *)params
{
	NSString *version = @"2.0";
	
	NSString *pid = kProductID;
	NSString *mt = @"1";
	
	NSString *ver = [BZDeviceInfo appVersion];
	NSString *supPhone = [BZDeviceInfo platform];
	NSString *supFirm = [BZDeviceInfo osVersion];
	NSString *uuid  = [ZMDuid duid];
	
	NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
	NSString *jsonParam = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
	NSString *sign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",
					  pid, mt, ver, supPhone, supFirm, uuid, uuid, @"", version, (jsonParam ? jsonParam : @""), kServeRequestMagicCode];
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
	       pid, kHeaderPIDKey,
	       mt, kHeaderMTKey,
	       ver, kHeaderDivideVersionKey,
	       supPhone, kHeaderSupPhoneKey,
	       supFirm, kHeaderSupFirmKey,
	       uuid, kHeaderIMEIKey,
	       uuid, kHeaderIMSIKey,
	       version, kHeaderProtocolVersionKey,
	       [PHMD5String md5:sign], kHeaderSignKey,
	       nil];
	
	return dic;
}

@end
