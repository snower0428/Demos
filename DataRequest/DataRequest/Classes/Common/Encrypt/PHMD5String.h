//
//  PHMD5String.h
//  PHNetWorkInterface
//
//  Created by humin on 12-11-1.
//  Copyright 2012 nd.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PHMD5String : NSObject {

}

//32bit小写 md5加密
+ (NSString *)md5:(NSString *)str;
+ (NSString *)md5HexDigest:(NSString*)input;

@end
