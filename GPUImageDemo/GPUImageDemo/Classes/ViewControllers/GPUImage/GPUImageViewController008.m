//
//  GPUImageViewController008.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/4.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewController008.h"
#import "THImageMovieWriter.h"
#import "THImageMovie.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface GPUImageViewController008 ()

@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, strong) THImageMovieWriter *movieWriter;
@property (nonatomic, strong) dispatch_group_t recordDispatchGroup;
@property (nonatomic, strong) THImageMovie *imageMovie0;
@property (nonatomic, strong) THImageMovie *imageMovieOne;
@property (nonatomic, strong) THImageMovie *imageMovieTwo;
@property (nonatomic, strong) GPUImageBrightnessFilter *brightnessFilter;
@property (nonatomic, strong) GPUImageMaskFilter *filter;
@property (nonatomic, strong) GPUImageView *imageView;

@end

@implementation GPUImageViewController008

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self setupUI];
    [self setupConfiguration];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Object Private Function

- (void)setupUI
{
    //展示视图
    self.imageView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    _imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imageView];
    
    //Label
    self.displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 200, 150)];
    self.displayLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.displayLabel];
}

- (void)setupConfiguration
{
    self.brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    
    self.filter = [[GPUImageMaskFilter alloc] init];
    [self.filter setBackgroundColorRed:0.0 green:1.0 blue:0.0 alpha:0.1];
//    [filter setMix:0.5];
    
    NSURL *demoURL0 = [[NSBundle mainBundle] URLForResource:@"color4" withExtension:@"mp4"];
    self.imageMovie0 = [[THImageMovie alloc] initWithURL:demoURL0];
    self.imageMovie0.playAtActualSpeed = YES;
    
    //播放
    NSURL *demoURL1 = [[NSBundle mainBundle] URLForResource:@"color3" withExtension:@"mp4"];
    self.imageMovieOne = [[THImageMovie alloc] initWithURL:demoURL1];
//    self.imageMovieOne.runBenchmark = YES;
    self.imageMovieOne.playAtActualSpeed = YES;
    
    NSURL *demoURL2 = [[NSBundle mainBundle] URLForResource:@"mask3" withExtension:@"mp4"];
    self.imageMovieTwo = [[THImageMovie alloc] initWithURL:demoURL2];
//    self.imageMovieTwo.runBenchmark = YES;
    self.imageMovieTwo.playAtActualSpeed = YES;
    
    NSArray *imageMovieArr = @[self.imageMovieOne, self.imageMovieTwo];
    
    //存储路径
    NSString *pathStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathStr UTF8String]);
    //NSURL *movieURL = [NSURL URLWithString:pathStr];
    NSURL *movieURL = [NSURL fileURLWithPath:pathStr];
    
    //写入
    self.movieWriter = [[THImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720, 1280) movies:imageMovieArr];
    
//    [self.imageMovie0 addTarget:self.brightnessFilter];
    
    //添加响应链
    [self.imageMovieOne addTarget:self.filter];
    [self.imageMovieTwo addTarget:self.filter];
    
//    [self.brightnessFilter addTarget:self.filter];
    
    //显示
    [self.filter addTarget:self.imageView];
    [self.filter addTarget:self.movieWriter];
    
//    [self.imageMovie0 startProcessing];
    [self.imageMovieOne startProcessing];
    [self.imageMovieTwo startProcessing];
    [self.movieWriter startRecording];
    
    //进度显示
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [displayLink setPaused:NO];
    
    //存储
    __weak typeof(self) weakSelf = self;
    [self.movieWriter setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.filter removeTarget:strongSelf.self.movieWriter];
//        [strongSelf.imageMovie0 endProcessing];
        [strongSelf.imageMovieOne endProcessing];
        [strongSelf.imageMovieTwo endProcessing];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathStr))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     if (error) {
                         NSLog(@"保存失败");
                     } else {
                         NSLog(@"保存成功");
                     }
                 });
             }];
        }
        else {
            NSLog(@"error mssg)");
        }
    }];
}

- (void)updateProgress
{
    self.displayLabel.text = [NSString stringWithFormat:@"Progress:%d%%", (int)(self.imageMovieOne.progress * 100)];
    [self.displayLabel sizeToFit];
}

@end
