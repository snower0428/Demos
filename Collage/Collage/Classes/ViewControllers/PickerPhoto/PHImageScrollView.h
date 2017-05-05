//
//  PHImageScrollView.h
//  ImagesCombine
//
//  Created by ZZF on 13-8-28.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PHImageScrollViewDelegate;

@interface PHImageScrollView : UIView
{
    id<PHImageScrollViewDelegate>  _delegate;
    
    UIScrollView        *_scrollView;
    NSArray             *_listItems;
    NSInteger           _itemIndex;
}

@property(nonatomic, assign) id<PHImageScrollViewDelegate> delegate;
@property(nonatomic, retain) NSArray *listItems;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)updateItems:(NSArray *)items;

@end

//
// ThemeScrollViewDelegate
//
@protocol PHImageScrollViewDelegate <NSObject>
@optional

- (void)didRemoveItemWithIndex:(int)index;

@end
