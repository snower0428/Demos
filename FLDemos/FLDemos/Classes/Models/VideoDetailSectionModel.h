//
//  VideoDetailSectionModel.h
//  FLDemos
//
//  Created by leihui on 2020/2/10.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoDetailItem : NSObject <IGListDiffable>

@property (nonatomic, strong) NSString *previewUrl;
@property (nonatomic, strong) NSString *videoUrl;

@end

@interface VideoDetailSectionModel : NSObject <IGListDiffable>

@property (nonatomic, strong) NSArray *arrayData;

@end

NS_ASSUME_NONNULL_END
