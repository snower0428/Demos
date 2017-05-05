//
//  ModeCombineView.h
//  ImagesCombine
//
//  Created by ZZF on 13-8-30.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

/*****
      配置文件记录每张图片所在的区域,每张图片在所在的区域中进行缩放，移动等操作 
 */

#import <UIKit/UIKit.h>
#import "ImageZoomView.h"

@interface ModeCombineView : UIView<ImageZoomViewDelegate>{
    UIImageView * backView;
    UIImageView * touchView;
    NSInteger selectIndex;
}

@property (nonatomic, retain) NSDictionary * plistDic;
@property (nonatomic, retain) NSArray * modeArray;
@property (nonatomic, readonly) NSInteger typeIndex;
@property (nonatomic, readonly) NSInteger backIndex;
@property (nonatomic, readonly) NSInteger imageCount;

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images;
-(void)changeImagesFrame:(NSInteger)typeindex;
-(void)changeImagesBackgroud:(NSInteger)typeindex;

@end
