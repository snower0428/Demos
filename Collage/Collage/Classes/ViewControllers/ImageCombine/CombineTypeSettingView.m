//
//  CombineTypeSettingView.m
//  ImagesCombine
//
//  Created by ZZF on 13-9-9.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import "CombineTypeSettingView.h"
#import <QuartzCore/QuartzCore.h>
#import "ImagesCombineViewCtrl.h"

@implementation CombineTypeSettingView

#define DEFAULT_SCROLL_ITEM     8
#define SCROLL_ITEM_WIDTH       45
#define SCROLL_ITEM_HEIGHT      45
#define SCROLL_ITEM_INTERVAL    10

#define SCROLL_ITEM_OFFSET      0

#define IMAGE_TAG               2000
#define SELECTVIEW_TAG          1000

extern const int kTypeSettingViewTag;
extern const int kBackgroundSettingViewTag;

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        currentIndex = 0;
        self.backgroundColor = [UIColor clearColor];
        
        _typeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(SCROLL_ITEM_OFFSET, 0, self.frame.size.width, self.frame.size.height)];
        _typeScrollView.showsVerticalScrollIndicator = NO;
        _typeScrollView.showsHorizontalScrollIndicator = NO;
        _typeScrollView.pagingEnabled = NO;
        [self addSubview:_typeScrollView];

        //关闭按钮
//        UIImage *closeImage = [UIImage imageNamed:@"Resource/Image/ImageCombine/closeBtn.png"];
//		UIButton * closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//		closeButton.frame = CGRectMake(frame.size.width-25, 0, 20.0f, 20.0f);
//        [closeButton setImage:closeImage forState:UIControlStateNormal];
//        [closeButton addTarget:self action:@selector(removeViewAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:closeButton];
//		[closeButton release];
    }
    return self;
}

-(void)initWithSubViews:(NSInteger)itemCount selectIndex:(NSInteger)selectIndex type:(NSInteger)type backgroundType:(NSInteger)backgroundType imageCount:(NSInteger)imageCount
{
    //选择框
    UIView * selectView = [[UIView alloc] initWithFrame:CGRectMake(8, 3, SCROLL_ITEM_WIDTH+4, SCROLL_ITEM_HEIGHT+4)];
    selectView.tag = SELECTVIEW_TAG;
    //        selectView.layer.masksToBounds=YES;
    selectView.layer.cornerRadius=8.0;
    selectView.layer.borderWidth=2.0;
    selectView.layer.borderColor=[RGB(79, 177, 255) CGColor];
    
    int space = 10;
    for (int i = 0; i < itemCount; i++)
    {
        //Icon
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCROLL_ITEM_WIDTH+space, 5, SCROLL_ITEM_WIDTH, SCROLL_ITEM_HEIGHT)];
        icon.userInteractionEnabled = YES;
        icon.backgroundColor = [UIColor clearColor];
        
        NSString *fileName = @"";
        
        if (type == MODE_SHOWTYPE) {
            fileName = [NSString stringWithFormat:@"modeLayout/%ld_%d.png", (long)imageCount, i+1];
        }
        else if (type == FREE_SHOWTYPE) {
            fileName = [NSString stringWithFormat:@"freeLayout/%ld_%d.png", (long)imageCount, i+1];
        }
        
        if (backgroundType == BackgroundTypePhotoFrame) {
            //默认为白色相框
            if (i==0) {
                icon.backgroundColor = [UIColor whiteColor];
                icon.layer.cornerRadius = 8;
                fileName = @"";
            }else
                fileName = [NSString stringWithFormat:@"modeBorder/modeBorderIcon%d.png", i];
        }
        else if (backgroundType == BackgroundTypeBackground) {
            //默认为白色背景
//            if (i==0) {
//                icon.backgroundColor = [UIColor whiteColor];
//                icon.layer.cornerRadius = 8;
//                fileName = @"";
//            }else
                fileName = [NSString stringWithFormat:@"modeBorder/freeBgIcon%d.png", i];
        }
        
        NSString *path = [kPathForImageCombineResourceBundle stringByAppendingPathComponent:fileName];
        icon.image = [UIImage imageWithContentsOfFile:path];
        icon.tag = IMAGE_TAG + i;
        [_typeScrollView addSubview:icon];
        [icon release];
        space += SCROLL_ITEM_INTERVAL;
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTouched:)];
        [icon addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        if (i == selectIndex) {
            currentIndex = selectIndex;
            selectView.center = icon.center;
        }
    }
    
    _typeScrollView.contentSize = CGSizeMake(SCROLL_ITEM_WIDTH*itemCount+SCROLL_ITEM_INTERVAL*itemCount+SCROLL_ITEM_OFFSET+10, _typeScrollView.frame.size.height);
    
    [_typeScrollView addSubview:selectView];
    
    if (self.tag == kBackgroundSettingViewTag && type == FREE_SHOWTYPE) {
        CGRect btnFrame = CGRectMake(itemCount*SCROLL_ITEM_WIDTH + itemCount*SCROLL_ITEM_INTERVAL + 10, 5, SCROLL_ITEM_WIDTH, SCROLL_ITEM_HEIGHT);
        UIButton *btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
        btnMore.frame = btnFrame;
        btnMore.tag = IMAGE_TAG + itemCount;
        NSString *imagePath = [kPathForImageCombineResourceBundle stringByAppendingPathComponent:@"modeBorder/freeBgMore.png"];
        [btnMore setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
        [btnMore addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [_typeScrollView addSubview:btnMore];
        
        if (selectIndex == itemCount) {
            currentIndex = selectIndex;
            selectView.center = btnMore.center;
        }
        
        _typeScrollView.contentSize = CGSizeMake(SCROLL_ITEM_WIDTH*(itemCount+1)+SCROLL_ITEM_INTERVAL*(itemCount+1)+SCROLL_ITEM_OFFSET + 10, _typeScrollView.frame.size.height);
    }
    
    [selectView release];
}

- (void)removeViewAction:(id)sender{
    [self removeFromSuperview];
    if (delegate && [delegate respondsToSelector:@selector(removeViewAction)]) {
        [delegate removeViewAction];
    }
}

- (void)imageTouched:(id)sender{
    UITapGestureRecognizer * tapGesture = (UITapGestureRecognizer *)sender;
    NSInteger index = tapGesture.view.tag - IMAGE_TAG;

    if (index != currentIndex) {
        currentIndex = index;
        UIView * selectView = (UIView *)[_typeScrollView viewWithTag:SELECTVIEW_TAG];
        if (selectView) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            selectView.center = tapGesture.view.center;
            [UIView commitAnimations];
        }
        if (delegate && [delegate respondsToSelector:@selector(imageTouchedAction:typeIndex:)]) {
            [delegate imageTouchedAction:self typeIndex:index];
        }
        NSLog(@"#### image index %ld",(long)index);
    }
}

- (void)moreAction:(id)sender
{
    NSInteger index = ((UIButton *)sender).tag - IMAGE_TAG;
    if (delegate && [delegate respondsToSelector:@selector(moreActionWithIndex:)]) {
        currentIndex = index;
        UIView * selectView = (UIView *)[_typeScrollView viewWithTag:SELECTVIEW_TAG];
        if (selectView) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            selectView.center = ((UIButton *)sender).center;
            [UIView commitAnimations];
        }
        [delegate moreActionWithIndex:&index];
    }
}

@end
