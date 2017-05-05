//
//  PHImagePickerAssetView.h
//  ImagesCombine
//
//  Created by ZZF on 13-8-28.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// Delegate
#import "PHImagePickerAssetViewDelegate.h"

@interface PHImagePickerAssetView : UIView

@property (nonatomic, assign) id<PHImagePickerAssetViewDelegate> delegate;
@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL allowsMultipleSelection;

@end
