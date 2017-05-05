//
//  CombineImageView.h
//  ImagesCombine
//
//  Created by ZZF on 13-9-13.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CombineImageView : UIView<UIGestureRecognizerDelegate>{
    CGFloat _lastRotation;
}

@property (nonatomic, retain) UIImageView *photoImage;

-(void)setImage:(UIImage *)image;
-(UIImage *)getImage;
-(void)resetTransform;

@end
