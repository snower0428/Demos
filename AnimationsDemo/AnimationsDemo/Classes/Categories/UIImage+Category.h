//
//  UIImage+Category.h
//  UIImageScale
//
//  Created by Lin Xiaobin on 13-3-21.
//  Copyright (c) 2013年 Lost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Factory)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
+ (UIImage *)imageWithView:(UIView *)view;
+ (UIImage *)imageWithImage:(UIImage *)image;
+ (UIImage *)imageWithImages:(NSArray *)images size:(CGSize)size;
+ (UIImage *)imageWithImages:(NSArray *)images size:(CGSize)size scale:(CGFloat)scale;
@end


@interface UIImage (Mask)
- (UIImage *)imageWithMaskImage:(UIImage *)maskImage;
@end


@interface UIImage (Scale)
- (UIImage *)scaleImageToSize:(CGSize)size;
- (UIImage *)scaleImageToScreenSize;
- (UIImage *)jpgWithCompressionQuality:(CGFloat)compressionQuality;
@end


@interface UIImage (SubImage)
- (UIImage *)subImageInFrame:(CGRect)frame;
@end


@interface UIImage (File)
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;
- (BOOL)writeToJPGFile:(NSString *)path withCompressionQuality:(CGFloat)compressionQuality atomically:(BOOL)useAuxiliaryFile;

+ (void)writeImageTo:(NSString *)path withUrl:(NSString *)urlString;
@end

@interface UIImage (Blur)
- (UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end