//
//  CircleView.h
//  AnimationsDemo
//
//  Created by leihui on 17/3/2.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView

@property (nonatomic, strong) UIColor *strokeColor;

- (void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated;

@end
