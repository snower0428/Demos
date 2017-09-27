//
//  LoadImageOperation.h
//  GCDDemo
//
//  Created by leihui on 2017/9/26.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoadImageOperationDelegate;

@interface LoadImageOperation : NSOperation

@property (nonatomic, weak) id <LoadImageOperationDelegate> delegate;
@property (nonatomic, strong) NSString *imageUrl;

@end

#pragma mark - LoadImageOperationDelegate

@protocol LoadImageOperationDelegate <NSObject>
@optional

- (void)loadImageFinish:(UIImage *)image;

@end
