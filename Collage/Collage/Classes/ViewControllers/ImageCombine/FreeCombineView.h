//
//  FreeCombineView.h
//  ImagesCombine
//
//  Created by ZZF on 13-8-29.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

/*****
 配置文件记录每张图片所在的位置,其frame为一个长宽为 3/4 的区域,相应的图片根据配置文件的区域、角度进行缩放
 */

#import <UIKit/UIKit.h>

@interface FreeCombineView : UIView
{
    UIImageView * backView;
}

@property (nonatomic, retain) NSDictionary * plistDic;
@property (nonatomic, readonly) NSInteger typeIndex;
@property (nonatomic, readonly) NSInteger backIndex;
@property (nonatomic, readonly) NSInteger imageCount;

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images;
- (void)changeImagesFrame:(NSInteger)typeindex;
- (void)changeImagesBackgroud:(NSInteger)typeindex;
- (void)changeBackgroundWith:(UIImage *)image;
- (void)changeIndex:(NSInteger)index;

@end