//
//  VideoCollectionViewCell.h
//  FLDemos
//
//  Created by leihui on 2020/2/10.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCollectionViewCell : UICollectionViewCell

- (void)setImageWithUrl:(NSString *)strUrl;
- (void)playVideoWithUrl:(NSString *)strUrl;

@end

NS_ASSUME_NONNULL_END
