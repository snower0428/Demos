//
//  PHAssetCollectionView.h
//  ImagesCombine
//
//  Created by leihui on 13-12-2.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PHImagePickerAssetCellDelegate.h"
#import "PHImagePickerViewCtrl.h"
#import "PHAssetCollectionViewDelegate.h"

@interface PHAssetCollectionView : UIView <UITableViewDataSource, UITableViewDelegate, PHImagePickerAssetCellDelegate>
{
    id<PHAssetCollectionViewDelegate>   _collectionViewDelegate;
}

@property (nonatomic, retain) ALAssetsGroup *assetsGroup;

@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) QBImagePickerFilterType filterType;
@property (nonatomic, assign) BOOL showsHeaderButton;
@property (nonatomic, assign) BOOL showsFooterDescription;

@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL limitsMinimumNumberOfSelection;
@property (nonatomic, assign) BOOL limitsMaximumNumberOfSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

@property (nonatomic, retain) NSMutableArray *selectedAssets;
@property (nonatomic, assign) id<PHAssetCollectionViewDelegate> collectionViewDelegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)reloadData;

@end
