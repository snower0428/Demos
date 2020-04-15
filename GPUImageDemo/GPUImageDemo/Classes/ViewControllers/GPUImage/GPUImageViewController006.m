//
//  GPUImageViewController006.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/4.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewController006.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface GPUImageViewController006 ()

@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) GPUImageDissolveBlendFilter *blendFilter;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) GPUImageMovie *imageMovie;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageOutput *imageOut;
@property (nonatomic, copy) NSString *moviePath;
@property (nonatomic, strong) NSURL *movieURL;

@end

@implementation GPUImageViewController006

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self setupUI];
    [self setupConfiguration];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Object Private Function

- (void)setupConfiguration
{
    //实例化GPUImageDissolveBlendFilter
    self.blendFilter = [[GPUImageDissolveBlendFilter alloc] init];
    [self.blendFilter setMix:0.5];
    
    //播放视频
    NSURL *demoURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp4"];
    self.imageMovie = [[GPUImageMovie alloc] initWithURL:demoURL];
    self.imageMovie.runBenchmark = YES;
    self.imageMovie.playAtActualSpeed = YES;
    
    //实例化GPUImageVideoCamera
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    //路径
    NSString *moviePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([moviePath UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    self.moviePath = moviePath;
    self.movieURL = movieURL;
    
    //实例化GPUImageMovieWriter
    GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
    self.movieWriter = movieWriter;

    [self.videoCamera addTarget:self.blendFilter];
    [self.imageMovie addTarget:self.blendFilter];
    self.movieWriter.shouldPassthroughAudio = NO;
    self.imageMovie.audioEncodingTarget = self.movieWriter;
    self.movieWriter.encodingLiveVideo = NO;
    
    //开始并显示
    [self.blendFilter addTarget:self.imageView];
    [self.blendFilter addTarget:self.movieWriter];
    
    [self.videoCamera startCameraCapture];
    [self.movieWriter startRecording];
    [self.imageMovie startProcessing];
    
    //定时
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkDidWorkUpdateProgress)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    link.paused = NO;
    
    //存储
    __weak typeof(self) weakSelf = self;
    [movieWriter setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.blendFilter removeTarget:strongSelf.movieWriter];
        [strongSelf.movieWriter finishRecording];

        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(strongSelf.moviePath))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:strongSelf.movieURL completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{

                     if (error) {
                         NSLog(@"保存失败");
                     }
                     else {
                         NSLog(@"保存成功");
                     }
                 });
             }];
        }
    }];
}

- (void)setupUI
{
    //实例化GPUImageView
    self.imageView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.imageView];
    
    //实例化UILabel
    self.progressLabel = [[UILabel alloc] init];
    self.progressLabel.textColor = [UIColor redColor];
    self.progressLabel.font = [UIFont systemFontOfSize:20.0];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.progressLabel];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.bottom.equalTo(self.imageView).offset(-20.0);
        make.height.equalTo(@25);
        make.width.equalTo(self.imageView);
    }];
}

#pragma mark - Action && Notification

- (void)linkDidWorkUpdateProgress
{
    self.progressLabel.text = [NSString stringWithFormat:@"Progress = %.1f", self.imageMovie.progress * 100];
}

@end
