//
//  UIImage+Category.m
//  UIImageScale
//
//  Created by Lin Xiaobin on 13-3-21.
//  Copyright (c) 2013年 Lost. All rights reserved.
//

#import "UIImage+Category.h"
#include <QuartzCore/QuartzCore.h>

#ifndef isHDMachine
#define isHDMachine		([UIScreen mainScreen].scale > 1.f)
#define SCREEN_WIDTH        ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT       ([[UIScreen mainScreen] bounds].size.height)
#endif

#import <Accelerate/Accelerate.h>

@implementation UIImage (Factory)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    if (CGSizeEqualToSize(size, CGSizeZero))
    	return nil;
    
	UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithView:(UIView *)view
{
    if (view==nil || CGSizeEqualToSize(view.frame.size, CGSizeZero))
        return nil;
    
    //    UIGraphicsBeginImageContext(view.frame.size);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
    //====防止view缩放影响截屏区域
    CGContextConcatCTM(UIGraphicsGetCurrentContext(),view.transform);
    //===end by hm 16/9/1
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithImage:(UIImage *)image
{
    float scale = image.scale;
    CGSize imageSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    UIGraphicsBeginImageContext(imageSize);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:newImage.CGImage scale:scale orientation:UIImageOrientationUp];
}

+ (UIImage *)imageWithImages:(NSArray *)images size:(CGSize)size
{
    if (isHDMachine) {
        return [[self class] imageWithImages:images size:size scale:2.0];
    } else {
        return [[self class] imageWithImages:images size:size scale:1.0];
    }
}

+ (UIImage *)imageWithImages:(NSArray *)images size:(CGSize)size scale:(CGFloat)scale
{
    if (!images || [images count]==0 || CGSizeEqualToSize(size, CGSizeZero))
        return nil;
    
    size = CGSizeMake(size.width*scale, size.height*scale);
    
    UIGraphicsBeginImageContext(size);
    for (UIImage *image in images) {
        if (image && [image isKindOfClass:[UIImage class]])
        {
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        }
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:newImage.CGImage scale:scale orientation:UIImageOrientationUp];
}

@end


@implementation UIImage (Mask)

- (UIImage *)imageWithMaskImage:(UIImage *)maskImage
{
    if (!maskImage || ![maskImage isKindOfClass:[UIImage class]])
    {
        return self;
    }
    
    CGImageRef maskRef = [maskImage CGImage];
    CGImageRef cgMask =CGImageMaskCreate(CGImageGetWidth(maskRef), CGImageGetHeight(maskRef), CGImageGetBitsPerComponent(maskRef), CGImageGetBitsPerPixel(maskRef), CGImageGetBytesPerRow(maskRef), CGImageGetDataProvider(maskRef), NULL, true);
    CGImageRef maskedRef = CGImageCreateWithMask([self CGImage], cgMask);
    UIImage *resultImage = [UIImage imageWithCGImage:maskedRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(cgMask);
    CGImageRelease(maskedRef);
    
    return resultImage;
}

@end


@implementation UIImage(Scale)

- (UIImage *)scaleImageToSize:(CGSize)size
{
    if (!self || size.width==0 || size.height==0)
        return nil;
    
    float scale = self.scale;
    CGSize oldSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    CGSize newSize = CGSizeMake(size.width * scale, size.height * scale);
    
    //大小未改变，返回原图
    if (CGSizeEqualToSize(oldSize, newSize))
        return self;
    
    //得到图片的大小
    CGFloat width = oldSize.width;
    CGFloat height = oldSize.height;
    
    float horizontalRadio = newSize.width / width;
    float verticalRadio = newSize.height / height;
    float radio = verticalRadio > horizontalRadio ? verticalRadio : horizontalRadio;
    
    width = width * radio;
    height = height * radio;
    float xPos = (newSize.width - width) / 2;
    float yPos = (newSize.height - height) / 2;
    
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:scaledImage.CGImage scale:scale orientation:UIImageOrientationUp];
}

- (UIImage *)scaleImageToScreenSize
{
    UIImage *image = self;
    if (self.scale == 1.0 && isHDMachine)
    {
        image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:image.imageOrientation];
    }
    image = [image scaleImageToSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    return image;
}

- (UIImage *)jpgWithCompressionQuality:(CGFloat)compressionQuality
{
    NSData *data = UIImageJPEGRepresentation(self, compressionQuality);
	return [UIImage imageWithData:data];
}

@end

@implementation UIImage(SubImage)

- (UIImage *)subImageInFrame:(CGRect)frame
{
    CGSize size = frame.size;
    if (size.width==0 || size.height==0)
        return nil;
    
    float scale = self.scale;
    CGSize imageSize = CGSizeMake(frame.size.width*scale, frame.size.height*scale);
    CGRect drawFrame = CGRectMake(-frame.origin.x*scale, -frame.origin.y*scale, self.size.width*scale, self.size.height*scale);

    UIGraphicsBeginImageContext(imageSize);
    [self drawInRect:drawFrame];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:self.imageOrientation];
    
    return image;
}

@end



@implementation UIImage(File)

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile
{    
	NSData *data = nil;
    if ([[path pathExtension] compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
    	data = UIImagePNGRepresentation(self);
    }
    else if ([[path pathExtension] compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
    	data = UIImageJPEGRepresentation(self, 1.0);
    }
    else
    {
    	data = UIImagePNGRepresentation(self);
        if (data == nil)
        {
        	data = UIImageJPEGRepresentation(self, 1.0);
        }
    }
    
    return [data writeToFile:path atomically:YES];
}

- (BOOL)writeToJPGFile:(NSString *)path withCompressionQuality:(CGFloat)compressionQuality atomically:(BOOL)useAuxiliaryFile
{
	NSData *data = nil;
	if ([[path pathExtension] compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
    	data = UIImageJPEGRepresentation(self, compressionQuality);
    }
    
    return [data writeToFile:path atomically:YES];
}

+ (void)writeImageTo:(NSString *)path withUrl:(NSString *)urlString
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        if (data != nil && image != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [image writeToFile:path atomically:YES];
            });
        }
    });
}

@end

@implementation UIImage (Blur)

- (UIImage *)boxblurImageWithBlur:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 50);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
