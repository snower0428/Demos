//
//  GPUCustomFilter.h
//  GPUImageDemo
//
//  Created by leihui on 2020/3/4.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GPUImageCombinationFilter;

@interface GPUCustomFilter : GPUImageFilterGroup

@property (nonatomic, strong) GPUImageBilateralFilter *bilateralFilter;
@property (nonatomic, strong) GPUImageCannyEdgeDetectionFilter *cannyEdgeDetectionFilter;
@property (nonatomic, strong) GPUImageCombinationFilter *combinationFilter;
@property (nonatomic, strong) GPUImageHSBFilter *hsbFilter;

@end

NS_ASSUME_NONNULL_END
