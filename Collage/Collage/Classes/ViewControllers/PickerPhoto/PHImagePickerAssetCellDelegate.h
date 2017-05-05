//
//  PHImagePickerAssetCellDelegate.h
//  ImagesCombine
//
//  Created by ZZF on 13-8-28.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

@class PHImagePickerAssetCell;

@protocol PHImagePickerAssetCellDelegate <NSObject>

@required
- (BOOL)assetCell:(PHImagePickerAssetCell *)assetCell canSelectAssetAtIndex:(NSUInteger)index;
- (void)assetCell:(PHImagePickerAssetCell *)assetCell didChangeAssetSelectionState:(BOOL)selected atIndex:(NSUInteger)index;

@end