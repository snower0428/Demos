//
//  ModeCombineView.m
//  ImagesCombine
//
//  Created by ZZF on 13-8-30.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import "ModeCombineView.h"
#import <QuartzCore/QuartzCore.h>

@interface ModeCombineView()

-(void)initSubviews:(NSArray *)images;
-(void)initSubviews:(NSArray *)images typeIndex:(int)typeindex;

@end

@implementation ModeCombineView

@synthesize plistDic = _plistDic;
@synthesize modeArray = _modeArray;
@synthesize typeIndex = _typeIndex;
@synthesize backIndex= _backIndex;
@synthesize imageCount = _imageCount;

#define kImageViewTag 10000

- (void)dealloc
{
    self.plistDic = nil;
    self.modeArray = nil;
    [backView release];
    backView = nil;
    [touchView release];
    touchView = nil;

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        _typeIndex = 0;
        _imageCount = [images count];
        [self initSubviews:images];
    }
    return self;
}

-(void)initSubviews:(NSArray *)images{
    [self initSubviews:images typeIndex:0];
}

-(void)initSubviews:(NSArray *)images typeIndex:(int)typeindex{
        
    UIView  * modeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    modeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:modeView];
    [modeView release];
    
    backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
       backView.hidden = YES;
    [modeView addSubview:backView];

    NSString * plistName = [NSString stringWithFormat:@"Configuration/ModeCombine/ModeCombineConfig%lu.plist",(unsigned long)images.count];
    NSString * plistPath = [RESOURCE_PATH stringByAppendingPathComponent:plistName];
    self.plistDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    if(_plistDic == nil)
        return;
    NSArray  * viewsArray = [_plistDic objectForKey:@"views"];
    if(viewsArray == nil && typeindex >= viewsArray.count)
        return;

    self.modeArray = [viewsArray objectAtIndex:typeindex];
    if(_modeArray == nil)
        return;

    NSLog(@"#### %@",_modeArray);
    
    int index = 0;
    for (UIImage * image in images) {
        
        NSLog(@"####Image %f,%f",image.size.width,image.size.height);
        if (index < _modeArray.count) {
            CGRect rect = CGRectFromString([_modeArray objectAtIndex:index]);
            //适应iphone5
            if (iPhone5 || iPhone6OrPlus) {
                if (rect.origin.y != 5) {
                    rect.origin.y = rect.origin.y *(558/472.0);
                }
                rect.size.height = rect.size.height *(558/470.0);
                
                //适应的时候底标齐
                if (rect.origin.y + rect.size.height > 558) {
                    if (rect.origin.y + rect.size.height > 563) {
                        rect.origin.y -= (rect.origin.y + rect.size.height-563);
                    }else{
                        rect.origin.y += (563-(rect.origin.y + rect.size.height));
                    }
                }
            }
            
            rect.origin.x *= iPhoneWidthScaleFactor;
            rect.origin.y *= iPhoneWidthScaleFactor;
            rect.size.width *= iPhoneWidthScaleFactor;
            rect.size.height *= iPhoneWidthScaleFactor;
            
            ImageZoomView *photoView = [[ImageZoomView alloc] initWithFrame:rect];
            photoView.touchDelegate = self;
            photoView.tag = kImageViewTag+index;
            [photoView setImage:image];
            [photoView setBackgroundColor:[UIColor clearColor]];
            [modeView addSubview:photoView];
            [photoView release];
            index++;
        }
    }
    
    //拖动的缩略图
    touchView = [[UIImageView alloc] init];
    touchView.hidden = YES;
    touchView.alpha = 0.5;
    [self addSubview:touchView];
}

-(void)changeImagesFrame:(NSInteger)typeindex{
    
    if(_plistDic == nil)
        return;
    NSArray  * viewsArray = [_plistDic objectForKey:@"views"];
    if(viewsArray == nil && typeindex >= viewsArray.count)
        return;
    
    self.modeArray = [viewsArray objectAtIndex:typeindex];
    if(_modeArray == nil)
        return;

    _typeIndex = typeindex;
    int index = 0;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    for (NSString * rect in _modeArray) {
#pragma clang diagnostic pop
        CGRect rect = CGRectFromString([_modeArray objectAtIndex:index]);
        
        //适应iphone5
        if (iPhone5 || iPhone6OrPlus) {
            if (rect.origin.y != 5) {
                rect.origin.y = rect.origin.y *(558/472.0);
            }
            rect.size.height = rect.size.height *(558/470.0);
            
            //适应的时候底标齐
            if (rect.origin.y + rect.size.height > 558) {
                if (rect.origin.y + rect.size.height > 563) {
                    rect.origin.y -= (rect.origin.y + rect.size.height-563);
                }else{
                    rect.origin.y += (563-(rect.origin.y + rect.size.height));
                }
            }
        }
        
        rect.origin.x *= iPhoneWidthScaleFactor;
        rect.origin.y *= iPhoneWidthScaleFactor;
        rect.size.width *= iPhoneWidthScaleFactor;
        rect.size.height *= iPhoneWidthScaleFactor;
        
        ImageZoomView *photoView = (ImageZoomView *)[self viewWithTag:kImageViewTag+index];
        if (photoView ) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [photoView changeViewFrame:rect];
            [UIView commitAnimations];
        }
        index++;
    }
}

-(void)changeImagesBackgroud:(NSInteger)typeindex{
    _backIndex = typeindex;
//    UIEdgeInsets insets = UIEdgeInsetsMake(23, 23, 23, 23);
    NSString * imagePath=nil;
    if (iPhone5) {
        imagePath=[NSString stringWithFormat:@"modeBorder/modeBorder%ld_568.jpg",(long)typeindex];
    }else
        imagePath = [NSString stringWithFormat:@"modeBorder/modeBorder%ld.jpg",(long)typeindex];
    imagePath = [kPathForImageCombineResourceBundle stringByAppendingPathComponent:imagePath];
    
    UIImage * image =[UIImage imageWithContentsOfFile:imagePath];
    if (image) {
        backView.image = image;
        backView.hidden = NO;
    }else
        backView.hidden = YES;
}

#pragma mark - ImageZoomViewDelegate

-(void)imageTouchedMoved:(ImageZoomView *)view point:(CGPoint)point{
    if (touchView.image == nil) {
        UIImage * touchImage = [view getImage];
        CGSize  imageSize = touchImage.size;
        CGFloat width = 80;
        CGFloat height = width *imageSize.height/imageSize.width;
        touchView.frame = CGRectMake(0, 0, width, height);
        touchView.image = touchImage;
        touchView.hidden = NO;
    }
    touchView.center = point;
    
    //区域检测
    NSInteger index = 0;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    for (NSString * rect in _modeArray) {
#pragma clang diagnostic pop
        CGRect rect = CGRectFromString([_modeArray objectAtIndex:index]);
        
        rect.origin.x *= iPhoneWidthScaleFactor;
        rect.origin.y *= iPhoneWidthScaleFactor;
        rect.size.width *= iPhoneWidthScaleFactor;
        rect.size.height *= iPhoneWidthScaleFactor;
        
        if (CGRectContainsPoint(rect, point)) {
            if (selectIndex != index) {
                //还原选项框
                ImageZoomView *photoView = (ImageZoomView *)[self viewWithTag:kImageViewTag+selectIndex];
                photoView.layer.borderColor = nil;
                photoView.layer.borderWidth = 0;
            }
            ImageZoomView *photoView = (ImageZoomView *)[self viewWithTag:kImageViewTag+index];
            photoView.layer.borderColor = [UIColor orangeColor].CGColor;
            photoView.layer.borderWidth = 3.0;
            selectIndex = index;
        }
        index++;
    }
}

-(void)imageTouchedEnded:(ImageZoomView *)view point:(CGPoint)point{
    touchView.hidden = YES;
    touchView.image = nil;
    if (selectIndex != -1) {
        //1.还原选项框
        ImageZoomView *photoView = (ImageZoomView *)[self viewWithTag:kImageViewTag+selectIndex];
        photoView.layer.borderColor = nil;
        photoView.layer.borderWidth = 0;
        //2.判断是否为原视图
        if (photoView != view) {
            //3.交换图片
            UIImage * desImage = [photoView getImage];
            [photoView setImage:[view getImage]];
            [view setImage:desImage];
        }
        selectIndex = -1;
    }
}

@end
