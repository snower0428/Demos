//
//  TransparentVideoView.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/9.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "TransparentVideoView.h"

@interface TransparentVideoView ()

@property (nonatomic, strong) GPUImagePicture *backgroundPicture;

@property (nonatomic, strong) GPUImageBrightnessFilter *brightnessFilter;
@property (nonatomic, strong) GPUImageMaskFilter *filter;
@property (nonatomic, strong) GPUImageThreeInputFilter *threeInputFilter;
@property (nonatomic, strong) GPUImageMovie *imageMovie;
@property (nonatomic, strong) GPUImageMovie *imageMovieMask;
@property (nonatomic, strong) GPUImagePicture *sourcePicture;


@end

@implementation TransparentVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // Init
        self.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        
    }
    return self;
}

- (void)configuration {
    
//    self.threeInputFilter = [[GPUImageThreeInputFilter alloc] init];
    
//    self.brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
//    [self.brightnessFilter setBrightness:0];
//
//    self.backgroundPicture = [[GPUImagePicture alloc] initWithImage:getResource(@"test.jpg")];
//    [self.backgroundPicture processImage];
//    [self.backgroundPicture addTarget:self.brightnessFilter];
    
    self.filter = [[GPUImageMaskFilter alloc] init];
//    self.filter.thresholdSensitivity = 0.15;
//    self.filter.smoothing = 0.3;
//    [self.filter setColorToReplaceRed:1.f green:0.f blue:1.f];
        
    // 实例化GPUImageMovie
    NSURL *colorUrl = [[NSBundle mainBundle] URLForResource:@"color" withExtension:@"mp4"];
    self.imageMovie = [[GPUImageMovie alloc] initWithURL:colorUrl];
    self.imageMovie.playAtActualSpeed = YES;
    
    // 添加响应链
    [self.imageMovie addTarget:self.filter];
    [self.imageMovie startProcessing];
    
    // Transparent
//    UIImage *transparentImage = [UIImage imageNamed:@"transparent"];
//    self.source`Picture = [[GPUImagePicture alloc] initWithImage:transparentImage smoothlyScaleOutput:YES];
//    [self.sourcePicture addTarget:self.filter];
//    [self.sourcePicture processImage];
    
    NSURL *maskUrl = [[NSBundle mainBundle] URLForResource:@"mask" withExtension:@"mp4"];
    self.imageMovieMask = [[GPUImageMovie alloc] initWithURL:maskUrl];
    self.imageMovieMask.playAtActualSpeed = YES;
    [self.imageMovieMask addTarget:self.filter];
    [self.imageMovieMask startProcessing];
    
    [self.filter addTarget:self];
}

@end
