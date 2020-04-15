//
//  VPTemplateDIYPreviewView.h
//  GPUImageDemo
//
//  Created by leihui on 2020/3/19.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VPTemplateDIYPreviewViewDelegate <NSObject>

@optional

@end

@interface VPTemplateDIYPreviewView : UIView

- (void)process;

@end

NS_ASSUME_NONNULL_END
