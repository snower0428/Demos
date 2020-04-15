//
//  TestViewController.m
//  GPUImageDemo
//
//  Created by leihui on 17/3/14.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "TestViewController.h"
#import "TestVideoView.h"
#import "VPGPUImageBlendFilter.h"
#import "FLChromaKeyBlendFilter.h"
#import "FLVHSFilter.h"
#import "VPGPUImageMaskFilter.h"
#import "VPGPUImageMovie.h"

#import <AssetsLibrary/ALAssetsLibrary.h>

#import "WAVideoBox.h"

@interface TestViewController ()

@property (nonatomic, strong) TestVideoView *videoView;

@property (nonatomic, strong) NSURL *backgroundMovieURL0;
@property (nonatomic, strong) NSURL *backgroundMovieURL;
@property (nonatomic, strong) NSURL *maskMovieURL;

@property (nonatomic, strong) GPUImageView *imageView;

@property (nonatomic, strong) GPUImageChromaKeyBlendFilter *blendFilter;
@property (nonatomic, strong) GPUImageBrightnessFilter *brightFilter;
@property (nonatomic, strong) GPUImageMovie *backgroundMovie;
@property (nonatomic, strong) GPUImageMovie *srcMovie;
@property (nonatomic, strong) GPUImageMovie *finalMovie;

@property (nonatomic, strong) GPUImageMaskFilter *maskFilter;
@property (nonatomic, strong) GPUImageAlphaBlendFilter *alphaBlendFilter;
@property (nonatomic, strong) GPUImageAlphaBlendFilter *alphaBlendFilter2;
@property (nonatomic, strong) GPUImageDissolveBlendFilter *dissolveBlendFilter;
@property (nonatomic, strong) GPUImageView *backgroundView;

@property (nonatomic, strong) NSURL *colorUrl;
@property (nonatomic, strong) NSURL *maskUrl;
@property (nonatomic, strong) VPGPUImageMovie *colorMovie;
@property (nonatomic, strong) VPGPUImageMovie *maskMovie;

@property (nonatomic, strong) GPUImagePicture *backgroundPicture;

@property (nonatomic, strong) GPUImageUIElement *uiElement;

@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;

@property (nonatomic, strong) WAVideoBox *videoBox;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor orangeColor];
    
//    // 一行代码搞定导航栏透明度
//    [self wr_setNavBarBackgroundAlpha:0.f];
//    // 一行代码搞定导航栏两边按钮颜色
//    [self wr_setNavBarTintColor:[UIColor whiteColor]];
//    // 一行代码搞定状态栏是 default 还是 lightContent
//    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    self.videoView = [[TestVideoView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:self.videoView];
    
    /*
    self.backgroundMovieURL0 = [[NSBundle mainBundle] URLForResource:@"color4" withExtension:@"mp4"];
    self.backgroundMovieURL = [[NSBundle mainBundle] URLForResource:@"color4" withExtension:@"mp4"];
    self.maskMovieURL = [[NSBundle mainBundle] URLForResource:@"MaskMovie1" withExtension:@"m4v"];
    
    self.imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:_imageView];
    
    self.blendFilter = [[GPUImageChromaKeyBlendFilter alloc] init];
//    [self.blendFilter addKeyColor:[UIColor whiteColor]];
    self.blendFilter.thresholdSensitivity = 0.4;
    self.blendFilter.smoothing = 0.1;
    [self.blendFilter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
    
    self.finalMovie = [[GPUImageMovie alloc] initWithURL:self.maskMovieURL];
    self.finalMovie.playAtActualSpeed = YES;
    [self.finalMovie addTarget:self.blendFilter];
    
    self.srcMovie = [[GPUImageMovie alloc] initWithURL:self.backgroundMovieURL];
    self.srcMovie.playAtActualSpeed = YES;
    [self.srcMovie addTarget:self.blendFilter];
    
    
    
    [self.blendFilter addTarget:self.imageView];
    
    [self.srcMovie startProcessing];
    [self.finalMovie startProcessing];
     */
    
//    [self testPV];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self testPV2];
}

- (void)testPV {
    
    self.backgroundView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:_backgroundView];
    
    UILabel *lbText = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    lbText.backgroundColor = [UIColor redColor];
    lbText.text = @"水印";
    lbText.textColor = [UIColor whiteColor];
    lbText.textAlignment = NSTextAlignmentCenter;
    
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:lbText];
    
    self.uiElement = [[GPUImageUIElement alloc] initWithView:containerView];
    
    self.maskFilter = [[GPUImageMaskFilter alloc] init];
    self.alphaBlendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    [self.alphaBlendFilter setMix:1.0];
    self.alphaBlendFilter2 = [[GPUImageAlphaBlendFilter alloc] init];
    [self.alphaBlendFilter2 setMix:0.5];
    self.dissolveBlendFilter = [[GPUImageDissolveBlendFilter alloc] init];
    [self.dissolveBlendFilter setMix:0.5];
    
    self.colorUrl = [[NSBundle mainBundle] URLForResource:@"color0" withExtension:@"mp4"];
    self.maskUrl = [[NSBundle mainBundle] URLForResource:@"mask0" withExtension:@"mp4"];
    
    self.colorMovie = [[VPGPUImageMovie alloc] initWithURL:self.colorUrl];
    self.colorMovie.playAtActualSpeed = YES;
    [self.colorMovie addTarget:self.maskFilter];
    
    self.maskMovie = [[VPGPUImageMovie alloc] initWithURL:self.maskUrl];
    self.maskMovie.playAtActualSpeed = YES;
    [self.maskMovie addTarget:self.maskFilter];
    
    self.backgroundPicture = [[GPUImagePicture alloc] initWithImage:getResource(@"test.jpg")];
    [self.backgroundPicture addTarget:self.alphaBlendFilter];

    [self.maskFilter addTarget:self.alphaBlendFilter];
    
    [self.alphaBlendFilter addTarget:self.alphaBlendFilter2];
    [self.uiElement addTarget:self.alphaBlendFilter2];
    
    [self.alphaBlendFilter2 addTarget:_backgroundView];

    [self.alphaBlendFilter2 useNextFrameForImageCapture];
    [self.uiElement update];
    
    [self.backgroundPicture processImage];
    [self.colorMovie startProcessing];
    [self.maskMovie startProcessing];
    
//    kWeakSelf;
//    [self.dissolveBlendFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
//        [weakSelf.uiElement updateWithTimestamp:time];
//    }];
}

- (void)testPV2 {
    
    self.backgroundView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:_backgroundView];
    
    self.maskFilter = [[GPUImageMaskFilter alloc] init];
    
    self.colorUrl = [[NSBundle mainBundle] URLForResource:@"color0" withExtension:@"mp4"];
    self.maskUrl = [[NSBundle mainBundle] URLForResource:@"mask0" withExtension:@"mp4"];
    
    self.colorMovie = [[VPGPUImageMovie alloc] initWithURL:self.colorUrl];
    self.colorMovie.playSound = YES;
    self.colorMovie.playAtActualSpeed = YES;
    
    self.maskMovie = [[VPGPUImageMovie alloc] initWithURL:self.maskUrl];
    self.maskMovie.playAtActualSpeed = YES;
    
    [self.colorMovie addTarget:self.maskFilter];
    [self.maskMovie addTarget:self.maskFilter];
    
    [self.maskFilter addTarget:_backgroundView];
    
    [self.colorMovie startProcessing];
    [self.maskMovie startProcessing];
    
    NSString *moviePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mov"];
    unlink([moviePath UTF8String]);
    NSURL *movieUrl = [NSURL fileURLWithPath:moviePath];
    
    // Final movie writer
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieUrl
                                                                size:CGSizeMake(720, 1080)
                                                            fileType:AVFileTypeQuickTimeMovie
                                                      outputSettings:nil];
    
    
    
    // 使用源音源
//    self.movieWriter.shouldPassthroughAudio = YES;
    
//    self.colorMovie.audioEncodingTarget = self.movieWriter;
    
    [self.maskFilter addTarget:self.movieWriter];
    
    [self.movieWriter startRecording];
    
    kWeakSelf;
    [self.movieWriter setCompletionBlock:^{
        [weakSelf.maskFilter removeTarget:weakSelf.movieWriter];
        [weakSelf.movieWriter finishRecording];
//        weakSelf.colorMovie.audioEncodingTarget = nil;

//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
//            [library writeVideoAtPathToSavedPhotosAlbum:movieUrl completionBlock:^(NSURL *assetURL, NSError *error) {
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     if (error) {
//                         NSLog(@"保存失败");
//                     } else {
//                         NSLog(@"保存成功");
//                     }
//                 });
//             }];
//        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf save];
        });
    }];
}

- (void)save {
    
    NSString *colorPath = [[NSBundle mainBundle] pathForResource:@"color0" ofType:@"mp4"];
    
    NSString *moviePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mov"];
    NSString *finalPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FinalMovie.mov"];
    NSURL *finalUrl = [NSURL fileURLWithPath:finalPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:finalPath]) {
        [fileManager removeItemAtPath:finalPath error:nil];
    }
    if ([fileManager fileExistsAtPath:moviePath]) {
        self.videoBox = [[WAVideoBox alloc] init];
        _videoBox.ratio = WAVideoExportRatioHighQuality;
        [_videoBox appendVideoByPath:moviePath];
//        [_videoBox dubbedSoundBySoundPath:colorPath];
        [_videoBox dubbedSoundBySoundPath:colorPath volume:0.2 mixVolume:1.0 insertTime:0];
        [_videoBox asyncFinishEditByFilePath:finalPath progress:^(float progress) {
            NSLog(@"progress:%@", @(progress));
        } complete:^(NSError *error) {
            NSLog(@"complete error:%@", error);
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(finalPath)) {
                [library writeVideoAtPathToSavedPhotosAlbum:finalUrl completionBlock:^(NSURL *assetURL, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (error) {
                             NSLog(@"保存失败");
                         } else {
                             NSLog(@"保存成功");
                         }
                     });
                 }];
            }
        }];
    }
    
    
}

@end
