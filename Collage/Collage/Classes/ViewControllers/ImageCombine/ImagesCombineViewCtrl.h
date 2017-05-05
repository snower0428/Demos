//
//  ImagesCombineViewCtrl.h
//  ImagesCombine
//
//  Created by ZZF on 13-8-29.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreeCombineView.h"
#import "ModeCombineView.h"
#import "CombineTypeSettingView.h"

#define FreeBackColor RGB(31, 44, 53)

@class ImagesCombineViewCtrl;

@protocol ImagesCombineViewCtrlDelegate <NSObject>
@optional
- (void)ImagesCombineViewCtrlDone:(ImagesCombineViewCtrl *)viewController image:(UIImage *)image;
@end

typedef enum{
    MODE_SHOWTYPE   = 0,
	FREE_SHOWTYPE   = 1
}SHOWVIEWTYPE;

typedef enum
{
    BackgroundTypeNone = -1,
    BackgroundTypePhotoFrame = 0,
    BackgroundTypeBackground = 1,
}BackgroundType;

//@class ResourceUpdateManager;

@interface ImagesCombineViewCtrl : UIViewController<CombineTypeSettingViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    FreeCombineView * freeCombine;
    ModeCombineView * modeCombine;
    SHOWVIEWTYPE currentIndex;
    BackgroundType _backgroundType;
    UIButton * typeButton;
    UIButton * backgroundButton;
    UIButton * modeButton;
    UIButton * freeButton;
    
    CGFloat combineWidth;
    CGFloat combineHeight;
    int  backLevel; //记录层级
    float statusHeight;
    
	//ResourceUpdateManager *_resourceMgr;
}

@property(nonatomic, retain) NSArray *listImages;
@property (nonatomic, assign) id<ImagesCombineViewCtrlDelegate> delegate;

- (id)initWithImages:(NSArray *)images;

@end
