//
//  GPUImageViewTransparentViewController.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/9.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewTransparentViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface GPUImageViewTransparentViewController ()

//@property (nonatomic, strong) GPUImageSketchFilter *brightnessFilter;
@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, strong) GPUImageMovie *srcMovie;
@property (nonatomic, strong) GPUImageMovie *movie;
@property (nonatomic, strong) GPUImageView *backgroundView;
@property (nonatomic, strong) GPUImageView *videoView;

@property (nonatomic, strong) GPUImageMaskFilter *filter;
@property (nonatomic, strong) GPUImageMovie *imageMovieColor;
@property (nonatomic, strong) GPUImageMovie *imageMovieMask;

@property (nonatomic, strong) NSString *pathStr;
@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter2;

@property (nonatomic, strong) GPUImageAlphaBlendFilter *blendFilter;

@end

@implementation GPUImageViewTransparentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blueColor];
    
//    self.backgroundView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
//    self.backgroundView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
//    [self.view addSubview:_backgroundView];
    
    self.videoView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.videoView.backgroundColor = [UIColor clearColor];
    self.videoView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:_videoView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.filter = [[GPUImageMaskFilter alloc] init];
    
//    self.brightnessFilter = [[GPUImageSketchFilter alloc] init];

    
    
    
//    NSURL *movieUrl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp4"];
//    self.movie = [[GPUImageMovie alloc] initWithURL:movieUrl];
//    self.movie.playAtActualSpeed = YES;
//    [self.movie addTarget:self.filter];
    
    // 实例化GPUImageMovie
    NSURL *colorUrl = [[NSBundle mainBundle] URLForResource:@"color" withExtension:@"mp4"];
    self.imageMovieColor = [[GPUImageMovie alloc] initWithURL:colorUrl];
    self.imageMovieColor.playAtActualSpeed = YES;
    [self.imageMovieColor addTarget:self.filter];
    
    NSURL *maskUrl = [[NSBundle mainBundle] URLForResource:@"mask" withExtension:@"mp4"];
    self.imageMovieMask = [[GPUImageMovie alloc] initWithURL:maskUrl];
    self.imageMovieMask.playAtActualSpeed = YES;
    [self.imageMovieMask addTarget:self.filter];
    
    [self.filter addTarget:self.videoView];
    
    [self.movie startProcessing];
    [self.imageMovieColor startProcessing];
    [self.imageMovieMask startProcessing];
    
    
    [self save];
}

- (void)save {
    
    //存储相关
    NSString *pathStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathStr UTF8String]);
    self.pathStr = pathStr;
    NSURL *movieURL = [NSURL fileURLWithPath:pathStr];
    self.movieURL = movieURL;
    
    //实例化GPUImageMovieWriter
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720, 1280)];
    
//    [self.brightnessFilter addTarget:self.filter];
    [self.filter addTarget:self.movieWriter];
    
    [self.movieWriter startRecording];
    
    //存储
    __weak typeof(self) weakSelf = self;
    [self.movieWriter setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.filter removeTarget:strongSelf.movieWriter];
        [strongSelf.movieWriter finishRecording];
        
//        [strongSelf processPicture];
        [strongSelf processVideo];
        
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

- (void)processVideo {
    
    self.blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    [self.blendFilter setMix:0.8];
    
    NSURL *srcMovieUrl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp4"];
    self.srcMovie = [[GPUImageMovie alloc] initWithURL:srcMovieUrl];
    self.srcMovie.playAtActualSpeed = YES;
    [self.srcMovie addTarget:self.blendFilter];
    
    NSURL *movieUrl = [NSURL fileURLWithPath:self.pathStr];
    self.movie = [[GPUImageMovie alloc] initWithURL:movieUrl];
    self.movie.playAtActualSpeed = YES;
    [self.movie addTarget:self.blendFilter];
    
    [self.blendFilter addTarget:self.videoView];
    
    [self.srcMovie startProcessing];
    [self.movie startProcessing];
    
    //存储相关
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie2.m4v"];
    unlink([path UTF8String]);
    NSURL *url = [NSURL fileURLWithPath:path];
    
    self.movieWriter2 = [[GPUImageMovieWriter alloc] initWithMovieURL:url size:CGSizeMake(720, 1280)];
    [self.blendFilter addTarget:self.movieWriter2];
    [self.movieWriter2 startRecording];
        
    __weak typeof(self) weakSelf = self;
    [self.movieWriter2 setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.blendFilter removeTarget:strongSelf.movieWriter2];
        [strongSelf.movieWriter2 finishRecording];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error)
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

- (void)processPicture {
    
    self.blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    [self.blendFilter setMix:0.8];
    
    self.picture = [[GPUImagePicture alloc] initWithImage:getResource(@"test.jpg")];
    [self.picture addTarget:self.blendFilter];
    [self.picture processImage];
    
    NSURL *movieUrl = [NSURL fileURLWithPath:self.pathStr];
    self.movie = [[GPUImageMovie alloc] initWithURL:movieUrl];
    self.movie.playAtActualSpeed = YES;
    [self.movie addTarget:self.blendFilter];
    
    [self.blendFilter addTarget:self.videoView];
    
    [self.movie startProcessing];
    
    //存储相关
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie2.m4v"];
    unlink([path UTF8String]);
    NSURL *url = [NSURL fileURLWithPath:path];
    
    self.movieWriter2 = [[GPUImageMovieWriter alloc] initWithMovieURL:url size:CGSizeMake(720, 1280)];
    [self.blendFilter addTarget:self.movieWriter2];
    [self.movieWriter2 startRecording];
        
    __weak typeof(self) weakSelf = self;
    [self.movieWriter2 setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.blendFilter removeTarget:strongSelf.movieWriter2];
        [strongSelf.movieWriter2 finishRecording];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error)
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

- (void)addGPUImageFilter:(GPUImageFilter *)filter {
    
//    [self.filterGroup addFilter:filter];
//
//    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
//
//    NSInteger count = self.filterGroup.filterCount;
//    if (count == 1) {
//        // 设置初始滤镜
//        self.filterGroup.initialFilters = @[newTerminalFilter];
//        // 设置末尾滤镜
//        self.filterGroup.terminalFilter = newTerminalFilter;
//    } else {
//        GPUImageOutput<GPUImageInput> *terminalFilter    = self.filterGroup.terminalFilter;
//        NSArray *initialFilters                          = self.filterGroup.initialFilters;
//
//        [terminalFilter addTarget:newTerminalFilter];
//
//        // 设置初始滤镜
//        self.filterGroup.initialFilters = @[initialFilters[0]];
//        // 设置末尾滤镜
//        self.filterGroup.terminalFilter = newTerminalFilter;
//    }
}

@end
