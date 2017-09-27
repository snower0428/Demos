//
//  PathsDefines.h
//  UIKitDemo
//
//  Created by leihui on 2017/5/31.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#ifndef PathsDefines_h
#define PathsDefines_h

#define DOCUMENTS_DIRECTORY     [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define MAIN_BUNDLEPATH			[[NSBundle mainBundle] resourcePath]
#define kConfig_Path			[DOCUMENTS_DIRECTORY stringByAppendingPathComponent:@"Configuration"]

#define RESOURCE_PATH           [MAIN_BUNDLEPATH stringByAppendingPathComponent:@"Resource"]
#define RESOURCE_CONFIG_PATH    [RESOURCE_PATH stringByAppendingPathComponent:@"Configuration"]
#define DOCUMENTS_CONFIG_PATH   [DOCUMENTS_DIRECTORY stringByAppendingPathComponent:@"Configuration"]

#define JSON_PATH				[RESOURCE_PATH stringByAppendingPathComponent:@"JSON"]
#define kJsonTestFilePath		[JSON_PATH stringByAppendingPathComponent:@"test"]
#define kJsonRecommendFilePath	[JSON_PATH stringByAppendingPathComponent:@"recommend"]
#define kJsonCartoonFilePath	[JSON_PATH stringByAppendingPathComponent:@"cartoon"]

#define kDocSavedPath			[DOCUMENTS_DIRECTORY stringByAppendingPathComponent:@"Saved"]

#endif /* PathsDefines_h */
