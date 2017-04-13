//
//  PHMD5String.m
//  PHNetWorkInterface
//
//  Created by humin on 12-11-1.
//  Copyright 2012 nd.com.cn. All rights reserved.
//

#import "PHMD5String.h"
#import <commoncrypto/CommonDigest.h>

@implementation PHMD5String

+ (NSString *)md5:(NSString *)str 
{
    const char *cStr = [str UTF8String]; 
    unsigned char result[32]; 
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat: 
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7], 
            result[8], result[9], result[10], result[11], 
            result[12], result[13], result[14], result[15] 
            ]; 
}

+ (NSString *)md5HexDigest:(NSString*)input 
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }    
    return ret;
}

@end
