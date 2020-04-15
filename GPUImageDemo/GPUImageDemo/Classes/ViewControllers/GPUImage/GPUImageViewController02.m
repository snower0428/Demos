//
//  GPUImageViewController02.m
//  GPUImageDemo
//
//  Created by leihui on 17/4/12.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewController02.h"

@interface GPUImageViewController02 ()

@property (nonatomic, strong) GPUImageView *gpuImageView;
@property (nonatomic, strong) GPUImageVideoCamera *gpuVideoCamera;

@end

@implementation GPUImageViewController02

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.gpuVideoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
	self.gpuVideoCamera.outputImageOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	self.gpuImageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
	self.gpuImageView.fillMode = kGPUImageFillModeStretch;	// kGPUImageFillModePreserveAspectRatioAndFill
	[self.view addSubview:_gpuImageView];
	
#if 1
	GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
	[self.gpuVideoCamera addTarget:filter];
	[filter addTarget:_gpuImageView];
#else
	[self.gpuVideoCamera addTarget:_gpuImageView];
#endif
	
	[self.gpuVideoCamera startCameraCapture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private



@end
