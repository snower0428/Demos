//
//  GPUImageViewBlendViewController.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/5.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewBlendViewController.h"
#import "THImageMovie.h"
#import "THImageMovieWriter.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "GPUImageRemap.h"

@interface GPUImageViewBlendViewController ()

@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) GPUImageMaskFilter *blendFilter;
@property (nonatomic, strong) GPUImageMovie *imageMovie0;
@property (nonatomic, strong) GPUImageMovie *imageMovie1;
@property (nonatomic, strong) GPUImageMovie *imageMovie2;
@property (nonatomic, strong) NSString *moviePath;

@end

@implementation GPUImageViewBlendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self setupUI];
    
    self.blendFilter = [[GPUImageMaskFilter alloc] init];
    
    // 播放视频0
    NSURL *originUrl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp4"];
    self.imageMovie0 = [[GPUImageMovie alloc] initWithURL:originUrl];
    self.imageMovie0.playAtActualSpeed = YES;
    
    // 播放视频1
    NSURL *colorUrl = [[NSBundle mainBundle] URLForResource:@"color3" withExtension:@"mp4"];
    self.imageMovie1 = [[GPUImageMovie alloc] initWithURL:colorUrl];
    self.imageMovie1.playAtActualSpeed = YES;
    
    // 播放视频2
    NSURL *maskUrl = [[NSBundle mainBundle] URLForResource:@"mask3" withExtension:@"mp4"];
    self.imageMovie2 = [[GPUImageMovie alloc] initWithURL:maskUrl];
    self.imageMovie2.playAtActualSpeed = YES;
    
    // 存储路径
//    NSString *pathStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
//    unlink([pathStr UTF8String]);
//    NSURL *movieURL = [NSURL fileURLWithPath:pathStr];
    
    // 写入
//    self.movieWriter = [[THImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720, 1280) movies:arrayMovie];
    
    // 添加响应链
//    [self.imageMovie0 addTarget:self.blendFilter];
    [self.imageMovie1 addTarget:self.blendFilter];
    [self.imageMovie2 addTarget:self.blendFilter];
    
    // 显示
    [self.blendFilter addTarget:self.imageView];
//    [self.blendFilter addTarget:self.movieWriter];
    
//    [self.imageMovie0 startProcessing];
    [self.imageMovie1 startProcessing];
    [self.imageMovie2 startProcessing];
//    [self.movieWriter startRecording];
    
    //进度显示
//    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
//    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//    [displayLink setPaused:NO];
    
    // 存储
//    __weak typeof(self) weakSelf = self;
//    [self.movieWriter setCompletionBlock:^{
//        __strong typeof(self) strongSelf = weakSelf;
//        [strongSelf.blendFilter removeTarget:strongSelf.movieWriter];
////        [strongSelf.imageMovie0 endProcessing];
//        [strongSelf.imageMovie1 endProcessing];
//        [strongSelf.imageMovie2 endProcessing];
//
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathStr))
//        {
//            [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
//             {
//                 dispatch_async(dispatch_get_main_queue(), ^{
//
//                     if (error) {
//                         NSLog(@"保存失败");
//                     } else {
//                         NSLog(@"保存成功");
//                     }
//                 });
//             }];
//        }
//        else {
//            NSLog(@"error mssg)");
//        }
//    }];
}

- (void)setupUI {
    
    self.imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    _imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imageView];
    
    self.displayLabel = [[UILabel alloc] init];
    _displayLabel.textColor = [UIColor whiteColor];
    _displayLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_displayLabel];
    
    [_displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@40);
    }];
}

- (void)updateProgress
{
    self.displayLabel.text = [NSString stringWithFormat:@"Progress:%d%%", (int)(self.imageMovie0.progress * 100)];
}

@end
