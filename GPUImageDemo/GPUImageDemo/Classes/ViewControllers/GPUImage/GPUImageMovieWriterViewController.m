//
//  GPUImageMovieWriterViewController.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/25.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageMovieWriterViewController.h"
#import "THImageMovie.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface GPUImageMovieWriterViewController ()

@property (nonatomic, strong) GPUImageView *imageView;

@property (nonatomic, strong) NSURL *colorUrl;
@property (nonatomic, strong) NSURL *maskUrl;

@property (nonatomic, strong) GPUImageAlphaBlendFilter *maskFilter;
@property (nonatomic, strong) THImageMovie *maskColorMovie;
@property (nonatomic, strong) THImageMovie *maskMaskMovie;

@property (nonatomic, strong) NSString *maskMoviePath;
@property (nonatomic, strong) NSURL *maskMovieURL;
@property (nonatomic, strong) THImageMovieWriter *maskMovieWriter;

@end

@implementation GPUImageMovieWriterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:_imageView];
    
    self.colorUrl = [[NSBundle mainBundle] URLForResource:@"color3" withExtension:@"mp4"];
    self.maskUrl = [[NSBundle mainBundle] URLForResource:@"mask3" withExtension:@"mp4"];
    
    self.maskFilter = [[GPUImageAlphaBlendFilter alloc] init];
    
    // Mask color movie
    self.maskColorMovie = [[THImageMovie alloc] initWithURL:self.colorUrl];
    self.maskColorMovie.playAtActualSpeed = YES;
//    self.maskColorMovie.shouldRepeat = YES;
    [self.maskColorMovie addTarget:self.maskFilter];
    
    // Mask mask movie
    self.maskMaskMovie = [[THImageMovie alloc] initWithURL:self.maskUrl];
    self.maskMaskMovie.playAtActualSpeed = YES;
    [self.maskMaskMovie addTarget:self.maskFilter];
        
    [self.maskColorMovie startProcessing];
    [self.maskMaskMovie startProcessing];
    
    // Mask movie
    NSString *maskMoviePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MaskMovie.m4v"];
    unlink([maskMoviePath UTF8String]);
    self.maskMoviePath = maskMoviePath;
    NSURL *maskMovieURL = [NSURL fileURLWithPath:maskMoviePath];
    self.maskMovieURL = maskMovieURL;
        
    // Mask movie writer
//    self.maskMovieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:maskMovieURL size:CGSizeMake(720, 1280)];
    self.maskMovieWriter = [[THImageMovieWriter alloc] initWithMovieURL:maskMovieURL
                                                                   size:CGSizeMake(720, 1280)
                                                                 movies:@[self.maskColorMovie, self.maskMaskMovie]];
    // 使用源音源
    self.maskMovieWriter.shouldPassthroughAudio = YES;
    
    self.maskColorMovie.audioEncodingTarget = (GPUImageMovieWriter *)_maskMovieWriter;
    
    [self.maskFilter addTarget:_imageView];
    [self.maskFilter addTarget:_maskMovieWriter];
    
    [self.maskMovieWriter startRecording];
    
    CGFloat time = 6.5;
    dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
    kWeakSelf;
    dispatch_after(stopTime, dispatch_get_main_queue(), ^{
        
        [weakSelf.maskMovieWriter finishRecording];
        [weakSelf.maskFilter removeTarget:weakSelf.maskMovieWriter];
//        weakSelf.srcMovie.audioEncodingTarget = nil;
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(weakSelf.maskMoviePath)) {

            [library writeVideoAtPathToSavedPhotosAlbum:weakSelf.maskMovieURL completionBlock:^(NSURL *assetURL, NSError *error) {

                 dispatch_async(dispatch_get_main_queue(), ^{

                     if (error) {
                         NSLog(@"保存失败");
                     } else {
                         NSLog(@"保存成功");
                     }
                 });
             }];
        }
    });
    
//    kWeakSelf;
//    [self.maskMovieWriter setCompletionBlock:^{
//        [weakSelf.maskFilter removeTarget:weakSelf.maskMovieWriter];
//        weakSelf.maskColorMovie.audioEncodingTarget = nil;
//        [weakSelf.maskMovieWriter finishRecording];
//
//        NSLog(@"<<<<<<<<<< saveMaskMovieComplete >>>>>>>>>>");
//
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(weakSelf.maskMoviePath)) {
//            [library writeVideoAtPathToSavedPhotosAlbum:weakSelf.maskMovieURL completionBlock:^(NSURL *assetURL, NSError *error) {
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     if (error) {
//                         NSLog(@"保存失败");
//                     } else {
//                         NSLog(@"保存成功");
//                     }
//                 });
//             }];
//        }
//    }];
}

@end
