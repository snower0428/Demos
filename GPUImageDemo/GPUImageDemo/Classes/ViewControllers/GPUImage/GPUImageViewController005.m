//
//  GPUImageViewController005.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/4.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewController005.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface GPUImageViewController005 ()

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageSepiaFilter *sepiaFilter;
@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UILabel *timeDisplayLabel;
@property (nonatomic, assign) NSInteger timeValue;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GPUImageViewController005

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self setupUI];
    [self setupConfiguratuon];
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

- (void)setupUI
{
    //实例化GPUImageView
    self.imageView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.imageView];
    
    //按钮实例化
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordButton setTitle:@"录制" forState:UIControlStateNormal];
    [self.recordButton setTitle:@"结束" forState:UIControlStateSelected];
    [self.recordButton addTarget:self action:@selector(recordButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.recordButton];
    [self.recordButton sizeToFit];
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imageView.mas_bottom).offset(-50);
        make.centerX.equalTo(self.imageView);
    }];
    
    //显示时间label实例化
    self.timeDisplayLabel = [[UILabel alloc] init];
    self.timeDisplayLabel.hidden = YES;
    self.timeDisplayLabel.textColor = [UIColor redColor];
    self.timeDisplayLabel.font = [UIFont systemFontOfSize:16.0];
    
    [self.view addSubview:self.timeDisplayLabel];
    [self.timeDisplayLabel sizeToFit];
    [self.timeDisplayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.bottom.equalTo(self.recordButton.mas_top).offset(-15.0);
    }];
    
    //滑动条
    self.slider = [[UISlider alloc] init];
    [self.slider addTarget:self action:@selector(sliderDidSlide:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.recordButton.mas_top).offset(-40.0);
        make.centerX.equalTo(self.slider);
        make.height.equalTo(@30);
        make.width.equalTo(@(self.view.bounds.size.height));
    }];
}

- (void)setupConfiguratuon
{
    //实例化GPUImageVideoCamera
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    //实例化
    self.sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    
    [self.videoCamera addTarget:self.sepiaFilter];
    [self.sepiaFilter addTarget:self.imageView];
    [self.videoCamera startCameraCapture];
}

#pragma mark - Action && Notification

- (void)recordButtonDidClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie4.m4v"];
    NSURL *movieURL = [NSURL fileURLWithPath:savePath];
    if (button.selected) {
        unlink([savePath UTF8String]);
        self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        self.movieWriter.encodingLiveVideo = YES;
        
        [self.sepiaFilter addTarget:self.movieWriter];
        self.videoCamera.audioEncodingTarget = self.movieWriter;
        [self.movieWriter startRecording];
        
        self.timeValue = 0;
        self.timeDisplayLabel.hidden = NO;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerWork:) userInfo:nil repeats:YES];
    }
    else {
        self.timeDisplayLabel.hidden = YES;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        [self.sepiaFilter removeTarget:self.movieWriter];
        self.videoCamera.audioEncodingTarget = nil;
        [self.movieWriter finishRecording];
    
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(savePath))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
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
    }
}

- (void)timerWork:(NSTimer *)timer
{
    NSLog(@"%ld", self.timeValue);
    
    self.timeDisplayLabel.text = [NSString stringWithFormat:@"录制时间:%ld", self.timeValue ++];
    [self.timeDisplayLabel sizeToFit];
}

- (void)sliderDidSlide:(UISlider *)slider
{
    NSInteger factor = 5;
    [self.sepiaFilter setIntensity:slider.value * factor];
}

@end
