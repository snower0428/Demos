//
//  CombineTypeSettingView.h
//  ImagesCombine
//
//  Created by ZZF on 13-9-9.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CombineTypeSettingView;

@protocol CombineTypeSettingViewDelegate <NSObject>

@optional

- (void)imageTouchedAction:(CombineTypeSettingView *)view typeIndex:(NSInteger)index;
- (void)removeViewAction;
- (void)moreActionWithIndex:(NSInteger *)index;

@end

@interface CombineTypeSettingView : UIView{
    UIScrollView        *_typeScrollView;
    NSInteger currentIndex;
}

-(void)initWithSubViews:(NSInteger)itemCount selectIndex:(NSInteger)selectIndex type:(NSInteger)type backgroundType:(NSInteger)backgroundType imageCount:(NSInteger)imageCount;

@property (nonatomic, assign) id<CombineTypeSettingViewDelegate> delegate;

@end
