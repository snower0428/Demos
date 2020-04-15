//
//  VPDIYPreviewViewController.h
//  GPUImageDemo
//
//  Created by leihui on 2020/3/18.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VPDIYTemplateType) {
    
    VPDIYTemplateTypeDynamic = 0,   // 动态模板
    VPDIYTemplateTypeStatic,        // 静态模板
};

@interface VPDIYPreviewViewController : UIViewController

- (instancetype)initWithType:(VPDIYTemplateType)type;

@end

NS_ASSUME_NONNULL_END
