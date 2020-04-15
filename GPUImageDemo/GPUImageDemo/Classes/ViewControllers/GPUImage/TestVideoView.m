//
//  TestVideoView.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/17.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "TestVideoView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface TestVideoView ()

@property (nonatomic, strong) GPUImageView *backgroundImageView;
@property (nonatomic, strong) GPUImageView *imageView;

@property (nonatomic, strong) GPUImagePicture *backgroundPicture;
@property (nonatomic, strong) GPUImageMovie *movieColor;
@property (nonatomic, strong) GPUImageMovie *movieMask;

@property (nonatomic, strong) GPUImageMaskFilter *filter;

@property (nonatomic, strong) NSString *pathStr;
@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;

@property (nonatomic, strong) GPUImageChromaKeyBlendFilter *blendFilter;

@end

@implementation TestVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // Init
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    // Background
    self.backgroundImageView = [[GPUImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self addSubview:_backgroundImageView];
    
    // ImageView
    self.imageView = [[GPUImageView alloc] initWithFrame:self.bounds];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self addSubview:_imageView];
    
    self.backgroundPicture = [[GPUImagePicture alloc] initWithImage:getResource(@"test.jpg")];
    [self.backgroundPicture addTarget:self.backgroundImageView];
    [self.backgroundPicture processImage];
    
    self.filter = [[GPUImageMaskFilter alloc] init];
    
    // Color movie
    NSURL *colorUrl = [[NSBundle mainBundle] URLForResource:@"color" withExtension:@"mp4"];
    self.movieColor = [[GPUImageMovie alloc] initWithURL:colorUrl];
    self.movieColor.playAtActualSpeed = YES;
    [self.movieColor addTarget:self.filter];
    
    // Mask movie
    NSURL *maskUrl = [[NSBundle mainBundle] URLForResource:@"mask" withExtension:@"mp4"];
    self.movieMask = [[GPUImageMovie alloc] initWithURL:maskUrl];
    self.movieMask.playAtActualSpeed = YES;
    [self.movieMask addTarget:self.filter];
    
    [self.filter addTarget:self.imageView];
    
    [self.movieColor startProcessing];
    [self.movieMask startProcessing];
    
    UIButton *btnSaveMask = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSaveMask.frame = CGRectMake(0, 100, 100, 44);
    [self addSubview:btnSaveMask];
    [btnSaveMask addTarget:self action:@selector(saveMaskAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)saveMaskAction:(id)sender {
    
    [self saveMask];
}

- (void)saveMask {
    
    //存储相关
    NSString *pathStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathStr UTF8String]);
    self.pathStr = pathStr;
    NSURL *movieURL = [NSURL fileURLWithPath:pathStr];
    self.movieURL = movieURL;
    
    //实例化GPUImageMovieWriter
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720, 1280)];
    
    [self.filter addTarget:self.movieWriter];
    
    [self.movieWriter startRecording];
    
    //存储
    __weak typeof(self) weakSelf = self;
    [self.movieWriter setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.filter removeTarget:strongSelf.movieWriter];
        [strongSelf.movieWriter finishRecording];
        
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(strongSelf.pathStr))
//        {
//            [library writeVideoAtPathToSavedPhotosAlbum:strongSelf.movieURL completionBlock:^(NSURL *assetURL, NSError *error)
//             {
//                 dispatch_async(dispatch_get_main_queue(), ^{
//
//                     if (error) {
//                         NSLog(@"保存失败");
//                     }
//                     else {
//                         NSLog(@"保存成功");
//                     }
//                 });
//             }];
//        }
    }];
}

- (void)saveVideo {
    
    self.blendFilter = [[GPUImageChromaKeyBlendFilter alloc] init];
    
    // Color movie
    NSURL *url = [NSURL fileURLWithPath:self.pathStr];
    self.movieColor = [[GPUImageMovie alloc] initWithURL:url];
    self.movieColor.playAtActualSpeed = YES;
    [self.movieColor addTarget:self.filter];
}

@end
