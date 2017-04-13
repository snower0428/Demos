//
//  DemoViewCell.h
//  UICollectionViewDemo
//
//  Created by leihui on 17/3/22.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoItem.h"

@interface DemoViewCell : UICollectionViewCell

- (void)updateWithItem:(DemoItem *)item;

@end
