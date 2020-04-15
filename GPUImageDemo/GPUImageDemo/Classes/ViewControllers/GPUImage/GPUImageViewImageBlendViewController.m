//
//  GPUImageViewImageBlendViewController.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/5.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewImageBlendViewController.h"

@interface GPUImageViewImageBlendViewController ()

@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) GPUImageChromaKeyBlendFilter *blendFilter;
@property (nonatomic, strong) GPUImagePicture *imagePicture;
@property (nonatomic, strong) GPUImagePicture *transparentPicture;

@property (nonatomic, strong) GPUImageMovie *imageMovie1;
@property (nonatomic, strong) GPUImageMovie *imageMovie2;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) NSString *moviePath;

@end

@implementation GPUImageViewImageBlendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self setupUI];
    
    self.blendFilter = [[GPUImageChromaKeyBlendFilter alloc] init];
    self.blendFilter.thresholdSensitivity = 0.5;
    self.blendFilter.smoothing = 0.3;
    [self.blendFilter setColorToReplaceRed:0.11f green:0.11f blue:0.11f];
        
    // 显示图像
    self.imagePicture = [[GPUImagePicture alloc] initWithImage:getResource(@"test.jpg")];
//    [self.imagePicture addTarget:self.blendFilter];
    [self.imagePicture addTarget:self.imageView];
    [self.imagePicture processImage];
    
    // 实例化GPUImageMovie1
    NSURL *colorUrl = [[NSBundle mainBundle] URLForResource:@"color" withExtension:@"mp4"];
    self.imageMovie1 = [[GPUImageMovie alloc] initWithURL:colorUrl];
//    self.imageMovie1.runBenchmark = YES;
    self.imageMovie1.playAtActualSpeed = YES;
//    self.imageMovie1.shouldRepeat = YES;
    
    // 实例化GPUImageMovie2
    NSURL *maskUrl = [[NSBundle mainBundle] URLForResource:@"mask" withExtension:@"mp4"];
    self.imageMovie2 = [[GPUImageMovie alloc] initWithURL:maskUrl];
//    self.imageMovie2.runBenchmark = YES;
    self.imageMovie2.playAtActualSpeed = YES;
    
//    // 存储路径
//    NSString *pathStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
//    unlink([pathStr UTF8String]);
//    NSURL *movieURL = [NSURL fileURLWithPath:pathStr];
//
//    // 写入
//    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720, 1280)];
    
    // 添加响应链
    [self.imageMovie1 addTarget:self.blendFilter];
//    [self.imageMovie2 addTarget:self.blendFilter];
//
    [self.imageMovie1 startProcessing];
//    [self.imageMovie2 startProcessing];
    
    // Transparent
    UIImage *backgroundImage = getResource(@"transparent.png");
    self.transparentPicture = [[GPUImagePicture alloc] initWithImage:backgroundImage smoothlyScaleOutput:YES];
    
    [self.transparentPicture addTarget:self.blendFilter];
    [self.transparentPicture processImage];
    
    [self.blendFilter addTarget:self.imageView];
}

- (void)setupUI {
    
    self.imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:_imageView];
}

@end
