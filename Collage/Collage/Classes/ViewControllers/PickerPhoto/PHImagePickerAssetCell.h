//
//  PHImagePickerAssetCell.h
//  ImagesCombine
//
//  Created by ZZF on 13-8-28.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// Delegate
#import "PHImagePickerAssetCellDelegate.h"
#import "PHImagePickerAssetViewDelegate.h"

@interface PHImagePickerAssetCell : UITableViewCell <PHImagePickerAssetViewDelegate>

@property (nonatomic, assign) id<PHImagePickerAssetCellDelegate> delegate;
@property (nonatomic, copy) NSArray *assets;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) NSUInteger numberOfAssets;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) BOOL allowsMultipleSelection;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageSize:(CGSize)imageSize numberOfAssets:(NSUInteger)numberOfAssets margin:(CGFloat)margin;

- (void)selectAssetAtIndex:(NSUInteger)index;
- (void)deselectAssetAtIndex:(NSUInteger)index;
- (void)selectAllAssets;
- (void)deselectAllAssets;

@end
