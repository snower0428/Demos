//
//  PHAssetCollectionViewDelegate.h
//  ImagesCombine
//
//  Created by leihui on 13-12-3.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#ifndef ImagesCombine_PHAssetCollectionViewDelegate_h
#define ImagesCombine_PHAssetCollectionViewDelegate_h

@protocol PHAssetCollectionViewDelegate <NSObject>
@optional

- (void)collectionViewSelect:(ALAsset *)asset selectedAssets:(NSMutableArray *)selectedAssets;
- (void)didSelectedItemOutOfBounds;

@end

#endif
