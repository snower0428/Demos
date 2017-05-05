//
//  PHImagePickerAssetViewDelegate.h
//  ImagesCombine
//
//  Created by ZZF on 13-8-28.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

@class PHImagePickerAssetView;

@protocol PHImagePickerAssetViewDelegate <NSObject>

@required
- (BOOL)assetViewCanBeSelected:(PHImagePickerAssetView *)assetView;
- (void)assetView:(PHImagePickerAssetView *)assetView didChangeSelectionState:(BOOL)selected;

@end
