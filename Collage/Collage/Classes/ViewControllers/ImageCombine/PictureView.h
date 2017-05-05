//
//  PictureView.h
//  ImagesCombine
//
//  Created by ZZF on 13-8-29.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PictureView : UIView{
}

@property (nonatomic, retain, readonly) UIImageView *showImageView;

-(void)setRotateWithAngle:(CGFloat)angle;
-(void)setTransformDefault;

@end
