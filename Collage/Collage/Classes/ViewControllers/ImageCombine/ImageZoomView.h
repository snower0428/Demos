//
//  ImageZoomView.h
//  ImagesCombine
//
//  Created by ZZF on 13-8-30.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CombineImageView.h"

@class ImageZoomView;

@protocol ImageZoomViewDelegate <NSObject>

@optional

-(void)imageTouchedMoved:(ImageZoomView *)view point:(CGPoint)point;
-(void)imageTouchedEnded:(ImageZoomView *)view point:(CGPoint)point;

@end

@interface ImageZoomView : UIScrollView <UIScrollViewDelegate>
{
    CombineImageView * _imageView;
    NSInteger _index;
    CGFloat imagescale;
    BOOL  isTouchMove; //判读是否为交换状态
}

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) id<ImageZoomViewDelegate> touchDelegate;

- (void)setImage:(UIImage *)newImage;
- (void)setImageUrl:(NSURL *)url;
-(UIImage *)getImage;

- (void)turnOffZoom;
- (void)setMaxMinZoomScalesForCurrentBounds;

-(void)changeViewFrame:(CGRect)frame;

@end
