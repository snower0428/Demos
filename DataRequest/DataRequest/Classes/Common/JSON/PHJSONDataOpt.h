//
//  PHJSONDataOpt.h
//  PHJSONDataOpt
//
//  Created by humin on 11-12-21.
//  Copyright 2011 nd.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHJSONDataOpt : NSObject {
	
}

//压缩上传NSData数据--配置信息
+ (NSData *)getPostConfigData:(NSDictionary *)data;
+ (NSString *)getPostConfigString:(NSDictionary *)obj;

//上传非压缩数据
+ (NSData *)getPostNormalConfigData:(NSDictionary *)obj;

//解析服务器下发数据
+ (id)parserjSONDataFromSvrEncodeByUTF8:(id)obj;
+ (id)parserjSONDataFromSvrEncodeByGBK:(id)obj;

@end
