//
//  PHImageSelectView.h
//  ImagesCombine
//
//  Created by ZZF on 13-8-28.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHImageScrollView.h"

@protocol PHImageSelectVIewDelegate <NSObject>
@optional
- (void)didRemoveItemWithIndex:(int)index;
@end

@interface PHImageSelectView : UIView<PHImageScrollViewDelegate>{
    PHImageScrollView * imageScrollView;
    UILabel * numLabel;
}

@property (nonatomic, retain) NSMutableArray *listItems;
@property(nonatomic, assign) id<PHImageSelectVIewDelegate> delegate;

- (void)removeAllItems;
- (void)updateItems;

@end
