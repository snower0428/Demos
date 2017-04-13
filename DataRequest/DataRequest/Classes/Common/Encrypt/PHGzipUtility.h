//
//  PHGzipUtility.h
//  ServiceInterface
//
//  Created by humin on 12-11-15.
//  Copyright 2012 nd.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PHGzipUtility : NSObject {

}

+(NSData*) gzipData: (NSData*)pUncompressedData;
+(NSData *) decompressData:( NSData *)compressedData;

@end
