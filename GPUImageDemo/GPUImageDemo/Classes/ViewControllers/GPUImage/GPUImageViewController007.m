//
//  GPUImageViewController007.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/4.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewController007.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface GPUImageViewController007 ()

@property (nonatomic, strong) GPUImageMovie *imageMovie;
@property (nonatomic, strong) GPUImageOutput <GPUImageInput> *blendFilter;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, copy) NSString *pathStr;
@property (nonatomic, strong) NSURL *movieURL;

@end

@implementation GPUImageViewController007

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self setupUI];
    [self setupConfig];
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
    
    //显示label
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.textColor = [UIColor blueColor];
    self.tipLabel.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:self.tipLabel];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(20.0);
    }];
}

- (void)setupConfig
{
    //滤镜
    self.blendFilter = [[GPUImageDissolveBlendFilter alloc] init];
    [(GPUImageDissolveBlendFilter *)self.blendFilter setMix:0.5];
    
    //播放
    NSURL *resourceURL = [[NSBundle mainBundle] URLForResource:@"color" withExtension:@"mp4"];
    AVAsset *asset = [AVAsset assetWithURL:resourceURL];
    
    //实例化GPUImageMovie
    self.imageMovie = [[GPUImageMovie alloc] initWithAsset:asset];
    self.imageMovie.runBenchmark = YES;
    self.imageMovie.playAtActualSpeed = YES;
    
    //水印提示文字
    UILabel *watermarkLabel = [[UILabel alloc] init];
    watermarkLabel.text  = @"水印";
    watermarkLabel.font = [UIFont systemFontOfSize:30.0];
    watermarkLabel.textColor = [UIColor redColor];
    
    //水印图片
    UIView *backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    UIImageView *watermarkImageView = [[UIImageView alloc] init];
    watermarkImageView.image = [UIImage imageNamed:@"light_4"];
    watermarkImageView.center = CGPointMake(kHeight / 2, kWidth / 2);
    
    [backView addSubview:watermarkLabel];
    [backView addSubview:watermarkImageView];
    
    [watermarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
        make.height.equalTo(@(50.0));
        make.width.equalTo(@(50.0));
    }];

    [watermarkLabel sizeToFit];
    [watermarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
    }];

    //实例化GPUImageUIElement
    GPUImageUIElement *uiElement = [[GPUImageUIElement alloc] initWithView:backView];

    //存储相关
    NSString *pathStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathStr UTF8String]);
    self.pathStr = pathStr;
    NSURL *movieURL = [NSURL fileURLWithPath:pathStr];
    self.movieURL = movieURL;
    
    //实例化GPUImageMovieWriter
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
    
    GPUImageFilter *imageFilter = [[GPUImageFilter alloc] init];
    [self.imageMovie addTarget:imageFilter];
    [imageFilter addTarget:self.blendFilter];
    [uiElement addTarget:self.blendFilter];
    
    self.movieWriter.shouldPassthroughAudio = YES;
    [self.imageMovie enableSynchronizedEncodingUsingMovieWriter:self.movieWriter];
    
    //显示
    [self.blendFilter addTarget:self.imageView];
    [self.blendFilter addTarget:self.movieWriter];
    [self.movieWriter startRecording];
    [self.imageMovie startProcessing];
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayProgress)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    displayLink.paused = NO;
    
    [imageFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time){
        CGRect frame = watermarkImageView.frame;
        frame.origin.x += 0.5;
        frame.origin.y += 0.5;
        watermarkImageView.frame = frame;
        [uiElement updateWithTimestamp:time];
    }];
    
    //存储
    __weak typeof(self) weakSelf = self;
    [self.movieWriter setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.blendFilter removeTarget:strongSelf.movieWriter];
        [strongSelf.movieWriter finishRecording];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(strongSelf.pathStr))
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

#pragma mark - Action && Notification

- (void)displayProgress
{
    NSLog(@"self.imageMovie.progress = %f", self.imageMovie.progress);
    self.tipLabel.text = [NSString stringWithFormat:@"Progress = %.2f%%",self.imageMovie.progress * 100];
    [self.tipLabel sizeToFit];
}

@end
