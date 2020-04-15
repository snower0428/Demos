//
//  GPUImageViewController002.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/4.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewController002.h"

@interface GPUImageViewController002 ()

@property (nonatomic, strong) GPUImageView *gpuImageView;
@property (nonatomic, strong) GPUImageVideoCamera *gpuImageVideoCamera;

@end

@implementation GPUImageViewController002

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self setupUI];
    [self setupCamera];
}

#pragma mark - Private

- (void)setupUI {
    
    self.gpuImageView = [[GPUImageView alloc] init];
    self.gpuImageView.frame = self.view.frame;
    [self.view addSubview:_gpuImageView];
}

- (void)setupCamera {
    
    // videoCamera
    self.gpuImageVideoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720
                                                                   cameraPosition:AVCaptureDevicePositionBack];
//    self.gpuImageVideoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    // GPUImageView填充模式
    self.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    // 滤镜
    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
    [self.gpuImageVideoCamera addTarget:filter];
    [filter addTarget:_gpuImageView];
    
    // Start camera capturing, 里面封装的是AVFoundation的session的startRunning
    [self.gpuImageVideoCamera startCameraCapture];
    
    // 屏幕方向的检测
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)orientationDidChange:(NSNotification *)notification {
    
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    self.gpuImageVideoCamera.outputImageOrientation = orientation;
    self.gpuImageView.frame = self.view.frame;
}

@end
