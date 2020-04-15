//
//  GPUImageViewController003.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/4.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewController003.h"
#import "GPUCustomFilter.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface GPUImageViewController003 ()

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) GPUCustomFilter *customFilter;
@property (nonatomic, copy) NSString *moviePath;
@property (nonatomic, strong) NSURL *movieURL;

@end

@implementation GPUImageViewController003

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self setupUI];
    [self beginConfiguration];
}

#pragma mark - Object Private Function

- (void)setupUI
{
    //配置GPUImageView
    self.imageView = [[GPUImageView alloc] init];
    self.imageView.frame = self.view.frame;
    [self.view addSubview:self.imageView];
}

- (void)beginConfiguration
{
    //配置GPUImageVideoCamera
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720
                                                           cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    //配置存储路径和URL
    NSString *moviePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"movie.m4v"];
    unlink([moviePath UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    self.moviePath = moviePath;
    self.movieURL = movieURL;
    
    //配置GPUImageMovieWriter
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720.0, 1280.0)];
    self.videoCamera.audioEncodingTarget = self.movieWriter;
    self.movieWriter.encodingLiveVideo = YES;
    [self.videoCamera startCameraCapture];
    
    //配置自定义滤镜 JJGPUCustomFilter
    self.customFilter = [[GPUCustomFilter alloc] init];
    [self.videoCamera addTarget:self.customFilter];
    [self.customFilter addTarget:self.imageView];
    [self.customFilter addTarget:self.movieWriter];
    [self.movieWriter startRecording];
    
    //存储视频
    [self storeVideo];
}

- (void)storeVideo
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.customFilter removeTarget:self.movieWriter];
        [self.videoCamera stopCameraCapture];
        [self.movieWriter finishRecording];

        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.moviePath)) {
            [assetLibrary writeVideoAtPathToSavedPhotosAlbum:self.movieURL completionBlock:^(NSURL *assetURL, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"保存视频失败");
                    }
                    else {
                        NSLog(@"保存视频成功");
                    }
                });
            }];
        }
        else {
            NSLog(@"路径不兼容");
        }
    });
}

@end
