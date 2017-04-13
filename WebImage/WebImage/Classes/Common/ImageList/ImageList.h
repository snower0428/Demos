//
//  ImageList.h
//  WebImage
//
//  Created by leihui on 17/3/28.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface ImageList : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ImageList);

- (NSArray *)list;

@end
