//
//  UIImage+Extend.m
//  CoreAnimationDemo
//
//  Created by leihui on 17/3/31.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage(Extend)

+ (UIImage *)imageWithView:(UIView *)view
{
	if (view==nil || CGSizeEqualToSize(view.frame.size, CGSizeZero)) {
		return nil;
	}
	
	UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
	//====防止view缩放影响截屏区域
	CGContextConcatCTM(UIGraphicsGetCurrentContext(),view.transform);
	//===end by hm 16/9/1
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

@end
