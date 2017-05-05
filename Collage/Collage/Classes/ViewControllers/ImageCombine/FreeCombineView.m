//
//  FreeCombineView.m
//  ImagesCombine
//
//  Created by ZZF on 13-8-29.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import "FreeCombineView.h"
#import "PictureView.h"
#import "ImagesCombineViewCtrl.h"

@interface FreeCombineView()

-(void)initSubviews:(NSArray *)images typeIndex:(int)typeindex;
//比较图片的长宽和视图的长宽，从而可以适当的缩放图片的大小
-(CGSize)getImageSizeWithOriginal:(CGSize)imageSize modeSize:(CGSize)modeSize;
//绘制边框
- (UIImage*)imageWithBorderFromImage:(UIImage*)source;

@end

@implementation FreeCombineView

@synthesize plistDic = _plistDic;
@synthesize typeIndex = _typeIndex;
@synthesize backIndex= _backIndex;
@synthesize imageCount = _imageCount;

#define kImageViewTag 10000

- (void)dealloc
{
    [backView release];
    backView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        _typeIndex = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        self.backgroundColor = FreeBackColor;
        _imageCount = [images count];
        [self initSubviews:images typeIndex:0];
    }
    return self;
}

- (void)initSubviews:(NSArray *)images typeIndex:(int)typeindex{
    
    //背景图
    backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    backView.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
//    backView.hidden = YES;
    [self changeImagesBackgroud:0];
    [self addSubview:backView];

    NSString * plistName = [NSString stringWithFormat:@"Resource/Configuration/ModeCombine/FreeCombineConfig%tu.plist",images.count];
    NSString * plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:plistName];
    self.plistDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if(_plistDic == nil)
        return;
    NSArray  * viewsArray = [_plistDic objectForKey:@"views"];
    if(viewsArray == nil)
        return;
    NSArray * modeArray = [viewsArray objectAtIndex:0];
    if(modeArray == nil)
        return;

    int index = 0;
    for (UIImage * image in images) {
        NSLog(@"#### %f,%f",image.size.width,image.size.height);
        if (index < modeArray.count) {
            NSDictionary * dic = [modeArray objectAtIndex:index];
            CGRect rect = CGRectFromString([dic objectForKey:@"frame"]);
            if (iPhone5 || iPhone6OrPlus) {
                rect.origin.y += 44;
            }
            
            rect.origin.x *= iPhoneWidthScaleFactor;
            rect.origin.y *= iPhoneWidthScaleFactor;
            rect.size.width *= iPhoneWidthScaleFactor;
            rect.size.height *= iPhoneWidthScaleFactor;
            
            CGFloat angle = [[dic objectForKey:@"angle"] floatValue];

            CGSize imageSize = image.size;
            CGSize rectsize = rect.size;
            CGSize size = [self getImageSizeWithOriginal:imageSize modeSize:rectsize];
            
            CGPoint center = CGPointMake(rect.origin.x + rect.size.width/2.0,rect.origin.y + rect.size.height/2.0);
            PictureView * photoview = [[PictureView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height)];
            photoview.tag = kImageViewTag+index;
            photoview.center = center;
            
//            CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
//            UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, 0.0);
//            [image drawInRect:CGRectMake(1,1,image.size.width-2,image.size.height-2)];
//            image = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
            
            photoview.showImageView.image = image;
            [photoview setRotateWithAngle:angle];
            [self addSubview:photoview];
            [photoview release];
            
            index ++;
        }
    }
}
       //绘制边框
- (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(10, 10, size.width-20, size.height-20);
//    CGRect borderRect = CGRectMake(0, 0, size.width, size.height);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
//    CGContextSetLineWidth(context, 20);
//    CGContextStrokeRect(context, borderRect);
//    CGContextSetAllowsAntialiasing(context, true);
//    CGContextSetShouldAntialias(context, true);
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}

- (void)changeImagesFrame:(NSInteger)typeindex{
    
    
    if(_plistDic == nil)
        return;
    NSArray  * viewsArray = [_plistDic objectForKey:@"views"];
    if(viewsArray == nil && typeindex >= viewsArray.count)
        return;
    
    NSArray * modeArray = [viewsArray objectAtIndex:typeindex];
    if(modeArray == nil)
        return;
    
    _typeIndex = typeindex;
    int index = 0;
    for (NSDictionary * dic in modeArray) {
        
        PictureView *photoView = (PictureView *)[self viewWithTag:kImageViewTag+index];
        if (photoView ) {
            //重置图片的样式
            [photoView setTransformDefault];
            CGRect rect = CGRectFromString([dic objectForKey:@"frame"]);
            if (iPhone5 || iPhone6OrPlus) {
                rect.origin.y += 44;
            }
            
            rect.origin.x *= iPhoneWidthScaleFactor;
            rect.origin.y *= iPhoneWidthScaleFactor;
            rect.size.width *= iPhoneWidthScaleFactor;
            rect.size.height *= iPhoneWidthScaleFactor;
            
            CGFloat angle = [[dic objectForKey:@"angle"] floatValue];
            
            CGSize imageSize = photoView.frame.size;
            CGSize rectsize = rect.size;
            CGSize size = [self getImageSizeWithOriginal:imageSize modeSize:rectsize];
            
            photoView.frame = CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
            CGPoint center = CGPointMake(rect.origin.x + rect.size.width/2.0,rect.origin.y + rect.size.height/2.0);
            photoView.center = center;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [photoView setRotateWithAngle:angle];
            [UIView commitAnimations];
        }
        index++;
    }
}

//比较图片的长宽和视图的长宽，从而可以适当的缩放图片的大小
- (CGSize)getImageSizeWithOriginal:(CGSize)imageSize modeSize:(CGSize)modeSize
{
    CGSize size = modeSize;
    if (imageSize.width == 0 || imageSize.height == 0) {
        return size;
    }
    
    BOOL isbool = (imageSize.width/imageSize.height) > (modeSize.width/modeSize.height);
    if (isbool) {
        size.width = modeSize.width;
        size.height = size.width*imageSize.height/imageSize.width;
    }else{
        size.height = modeSize.height;
        size.width = size.height*imageSize.width/imageSize.height;
    }
    return size;
}

- (void)changeImagesBackgroud:(NSInteger)typeindex
{
    _backIndex = typeindex;
    NSString * imagePath = [NSString stringWithFormat:@"modeBorder/freeBackground%d.jpg", (int)typeindex];
    imagePath = [kPathForImageCombineResourceBundle stringByAppendingPathComponent:imagePath];
    UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
    if (image) {
        if (!iPhone5) {
            image = [image scaleImageToSize:[UIScreen mainScreen].bounds.size];
        }
        backView.image = image;
        backView.hidden = NO;
    }else
        backView.hidden = YES;
}

- (void)changeIndex:(NSInteger)index
{
    _backIndex = index;
}

- (void)changeBackgroundWith:(UIImage *)image
{
    if (image) {
        backView.image = image;
        backView.hidden = NO;
    }
    else {
        backView.hidden = YES;
    }
}

@end

