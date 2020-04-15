//
//  VPDIYPreviewViewController.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/18.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "VPDIYPreviewViewController.h"
#import "THImageMovie.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "WAVideoBox.h"

@interface VPDIYPreviewViewController ()

@property (nonatomic, assign) VPDIYTemplateType templateType;

@property (nonatomic, strong) GPUImageView *backgroundView;
@property (nonatomic, strong) GPUImageView *previewVideoView;

@property (nonatomic, strong) NSURL *backgroundMovieURL;
@property (nonatomic, strong) GPUImageMovie *backgroundMovie;
@property (nonatomic, strong) NSURL *backgroundPictureURL;
@property (nonatomic, strong) GPUImagePicture *backgroundPicture;

@property (nonatomic, strong) NSURL *colorUrl;
@property (nonatomic, strong) NSURL *maskUrl;
@property (nonatomic, strong) GPUImageMaskFilter *previewFilter;
@property (nonatomic, strong) GPUImageMovie *previewColorMovie;
@property (nonatomic, strong) GPUImageMovie *previewMaskMovie;

@property (nonatomic, strong) GPUImageMaskFilter *maskFilter;
@property (nonatomic, strong) THImageMovie *maskColorMovie;
@property (nonatomic, strong) THImageMovie *maskMaskMovie;

@property (nonatomic, strong) NSString *maskMoviePath;
@property (nonatomic, strong) NSURL *maskMovieURL;
@property (nonatomic, strong) THImageMovieWriter *maskMovieWriter;

@property (nonatomic, strong) GPUImageChromaKeyBlendFilter *blendFilter;
@property (nonatomic, strong) THImageMovie *srcMovie;
@property (nonatomic, strong) THImageMovie *finalMovie;
@property (nonatomic, strong) THImageMovieWriter *finalMovieWriter;

@property (nonatomic, strong) GPUImageMovie *pictureMaskMovie;
@property (nonatomic, strong) GPUImageMovieWriter *pictureMovieWriter;
@property (nonatomic, strong) GPUImagePicture *picture;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, strong) UILabel *displayLabel2;

@property (nonatomic, assign) CGSize movieSize;

@property (nonatomic, assign) CMTime backgroundVideoTime;
@property (nonatomic, assign) CMTime foregroundVideoTime;
@property (nonatomic, assign) BOOL backgroundVideoShouldRepeat;

@property (nonatomic, strong) WAVideoBox *videoBox;

@end

@implementation VPDIYPreviewViewController

- (instancetype)initWithType:(VPDIYTemplateType)type {
    
    if (self = [super init]) {
        // Init
        _templateType = type;
        _movieSize = CGSizeMake(480, 640);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self initViews];
    [self initTopView];
    [self initProgressView];
    
    // 进度显示
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [displayLink setPaused:NO];
    
    _templateType = VPDIYTemplateTypeStatic;
    
    [self setupConfigurations];
    if (_templateType == VPDIYTemplateTypeDynamic) {
        [self setupBackgroundMovie];
    } else {
        [self setupBackgroundPicture];
    }
    [self setupForegroundMovie];
}

#pragma mark - Actions

- (void)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)videoMakerAction:(id)sender {
    
    [self setupMaskMovieWriter];
}

#pragma mark - Private

- (void)setupMaskMovieWriter {
    
    self.maskFilter = [[GPUImageMaskFilter alloc] init];
    [self.maskFilter setBackgroundColorRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    
    // Mask color movie
    self.maskColorMovie = [[THImageMovie alloc] initWithURL:self.colorUrl];
    self.maskColorMovie.playAtActualSpeed = YES;
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
    
    [self.maskFilter addTarget:_maskMovieWriter];
    
    [self.maskMovieWriter startRecording];
    
    kWeakSelf;
    [self.maskMovieWriter setCompletionBlock:^{
        [weakSelf.maskFilter removeTarget:weakSelf.maskMovieWriter];
        weakSelf.maskColorMovie.audioEncodingTarget = nil;
        [weakSelf.maskMovieWriter finishRecording];
        
        NSLog(@"<<<<<<<<<< saveMaskMovieComplete >>>>>>>>>>");
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(weakSelf.maskMoviePath)) {
            [library writeVideoAtPathToSavedPhotosAlbum:weakSelf.maskMovieURL completionBlock:^(NSURL *assetURL, NSError *error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (error) {
                         NSLog(@"保存失败");
                     } else {
                         NSLog(@"保存成功");
                         if (weakSelf.templateType == VPDIYTemplateTypeDynamic) {
                             if (weakSelf.backgroundVideoShouldRepeat) {
                                 [weakSelf handleVideo];
                             } else {
                                 [weakSelf saveMovieToAlbum];
                             }
                         } else {
                             [weakSelf savePictureToAlbum];
                         }
                     }
                 });
             }];
        }
    }];
}

- (void)handleVideo {
    
    kWeakSelf;
    [self handleBackgroundVideoProgress:^(float progress) {
        NSLog(@"progress:%@", @(progress));
    } complete:^(NSError *error) {
        NSLog(@"complete:%@", error);
        
        [weakSelf saveMovieToAlbum];
    }];
}

- (void)handleBackgroundVideoProgress:(void (^)(float progress))progress complete:(void (^)(NSError *error))complete {
    
    // 计算重复次数
    CGFloat backgroundVideoDuration = _backgroundVideoTime.value * 1.0 / _backgroundVideoTime.timescale;
    CGFloat foregroundVideoDuration = _foregroundVideoTime.value * 1.0 / _foregroundVideoTime.timescale;
    NSInteger videoRepeatCount = foregroundVideoDuration / backgroundVideoDuration + 1;
    
    // 视频路径
    NSString *backgroundMoviePath = [self.backgroundMovieURL path];
    
    self.videoBox = [[WAVideoBox alloc] init];
    _videoBox.ratio = WAVideoExportRatio1280x720;
    
    for (NSInteger i = 0; i < videoRepeatCount; i++) {
        [_videoBox appendVideoByPath:backgroundMoviePath];
    }
    [_videoBox rangeVideoByTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(_foregroundVideoTime.value, _foregroundVideoTime.timescale))];
    
    NSString *filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"DIY"] stringByAppendingPathComponent:@"temp.mp4"];
    self.backgroundMovieURL = [NSURL fileURLWithPath:filePath];
    
    [_videoBox asyncFinishEditByFilePath:filePath progress:progress complete:complete];
}

- (void)saveMovieToAlbum {
    
    self.blendFilter = [[GPUImageChromaKeyBlendFilter alloc] init];
    self.blendFilter.thresholdSensitivity = 0.4;
    self.blendFilter.smoothing = 0.1;
    [self.blendFilter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
    
    self.finalMovie = [[THImageMovie alloc] initWithURL:self.maskMovieURL];
    self.finalMovie.playAtActualSpeed = YES;
    [self.finalMovie addTarget:self.blendFilter];
    
    self.srcMovie = [[THImageMovie alloc] initWithURL:self.backgroundMovieURL];
    self.srcMovie.playAtActualSpeed = YES;
    self.srcMovie.shouldRepeat = _backgroundVideoShouldRepeat;
    [self.srcMovie addTarget:self.blendFilter];
    
    [self.srcMovie startProcessing];
    [self.finalMovie startProcessing];
    
    // Final movie
    NSString *finalMoviePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FinalMovie.m4v"];
    unlink([finalMoviePath UTF8String]);
    NSURL *finalMovieUrl = [NSURL fileURLWithPath:finalMoviePath];
    
    // Final movie writer
//    self.finalMovieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:finalMovieUrl size:CGSizeMake(720, 1280)];
    self.finalMovieWriter = [[THImageMovieWriter alloc] initWithMovieURL:finalMovieUrl
                                                                    size:CGSizeMake(720, 1280)
                                                                  movies:@[self.finalMovie, self.srcMovie]];
    // 使用源音源
    self.finalMovieWriter.shouldPassthroughAudio = YES;
    
    self.srcMovie.audioEncodingTarget = (GPUImageMovieWriter *)_finalMovieWriter;
    
    [self.blendFilter addTarget:_finalMovieWriter];
    
    [self.finalMovieWriter startRecording];
    
    kWeakSelf;
    [self.finalMovieWriter setCompletionBlock:^{
        [weakSelf.blendFilter removeTarget:weakSelf.finalMovieWriter];
        weakSelf.srcMovie.audioEncodingTarget = nil;
        [weakSelf.finalMovieWriter finishRecording];

        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(finalMoviePath)) {

            [library writeVideoAtPathToSavedPhotosAlbum:finalMovieUrl completionBlock:^(NSURL *assetURL, NSError *error) {

                 dispatch_async(dispatch_get_main_queue(), ^{

                     if (error) {
                         NSLog(@"保存失败");
                     } else {
                         NSLog(@"保存成功");
                     }
                 });
             }];
        }
    }];
}

- (void)savePictureToAlbum {
    
    self.blendFilter = [[GPUImageChromaKeyBlendFilter alloc] init];
    self.blendFilter.thresholdSensitivity = 0.4;
    self.blendFilter.smoothing = 0.1;
    [self.blendFilter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
    
    self.pictureMaskMovie = [[GPUImageMovie alloc] initWithURL:self.maskMovieURL];
    self.pictureMaskMovie.playAtActualSpeed = YES;
    [self.pictureMaskMovie addTarget:self.blendFilter];
    
    self.picture = [[GPUImagePicture alloc] initWithImage:getResource(@"test.jpg")];
    [_picture addTarget:self.blendFilter];
    
    [_picture processImage];
    [_pictureMaskMovie startProcessing];
    
    // Final movie
    NSString *finalMoviePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FinalMovie.m4v"];
    unlink([finalMoviePath UTF8String]);
    NSURL *finalMovieUrl = [NSURL fileURLWithPath:finalMoviePath];
    
    // Final movie writer
    self.pictureMovieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:finalMovieUrl size:CGSizeMake(720, 1280)];
//    self.finalMovieWriter = [[THImageMovieWriter alloc] initWithMovieURL:finalMovieUrl
//                                                                    size:CGSizeMake(720, 1280)
//                                                                  movies:@[self.finalMovie, self.srcMovie]];
    // 使用源音源
    self.pictureMovieWriter.shouldPassthroughAudio = YES;
    
    self.pictureMaskMovie.audioEncodingTarget = _pictureMovieWriter;
    
    [self.blendFilter addTarget:_pictureMovieWriter];
    
    [self.pictureMovieWriter startRecording];
    
    kWeakSelf;
    [self.pictureMovieWriter setCompletionBlock:^{
        [weakSelf.blendFilter removeTarget:weakSelf.pictureMovieWriter];
        weakSelf.pictureMaskMovie.audioEncodingTarget = nil;
        [weakSelf.pictureMovieWriter finishRecording];

        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(finalMoviePath)) {

            [library writeVideoAtPathToSavedPhotosAlbum:finalMovieUrl completionBlock:^(NSURL *assetURL, NSError *error) {

                 dispatch_async(dispatch_get_main_queue(), ^{

                     if (error) {
                         NSLog(@"保存失败");
                     } else {
                         NSLog(@"保存成功");
                     }
                 });
             }];
        }
    }];
}

- (void)setupConfigurations {
    
    // url配置
    self.backgroundMovieURL = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"];
    self.backgroundPictureURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"jpg"];
    
    self.colorUrl = [[NSBundle mainBundle] URLForResource:@"color3" withExtension:@"mp4"];
    self.maskUrl = [[NSBundle mainBundle] URLForResource:@"mask3" withExtension:@"mp4"];
    
    // 获取视频时长
    AVURLAsset *urlAssetBackground = [AVURLAsset assetWithURL:_backgroundMovieURL];
    self.backgroundVideoTime = [urlAssetBackground duration];
    NSLog(@"background video duration:%@, %@, %@", @(_backgroundVideoTime.value), @(_backgroundVideoTime.timescale),
          @(_backgroundVideoTime.value * 1.f / _backgroundVideoTime.timescale));
    
    AVURLAsset *urlAssetForeground = [AVURLAsset assetWithURL:_colorUrl];
    self.foregroundVideoTime = [urlAssetForeground duration];
    NSLog(@"foreground video duration:%@, %@, %@", @(_foregroundVideoTime.value), @(_foregroundVideoTime.timescale),
          @(_foregroundVideoTime.value * 1.f / _foregroundVideoTime.timescale));
    
    if (CMTimeCompare(_backgroundVideoTime, _foregroundVideoTime) < 0) {
        _backgroundVideoShouldRepeat = YES;
    }
}

- (void)setupBackgroundMovie {
    
    // Background movie
    self.backgroundMovie = [[GPUImageMovie alloc] initWithURL:self.backgroundMovieURL];
    self.backgroundMovie.playAtActualSpeed = YES;
    self.backgroundMovie.shouldRepeat = YES;
    [self.backgroundMovie addTarget:self.backgroundView];
    
    [self.backgroundMovie startProcessing];
}

- (void)setupBackgroundPicture {
    
    // Background picture
    self.backgroundPicture = [[GPUImagePicture alloc] initWithImage:getResource(@"test.jpg")];
    [_backgroundPicture addTarget:_backgroundView];
    
    [_backgroundPicture processImage];
}

- (void)setupForegroundMovie {
    
    self.previewFilter = [[GPUImageMaskFilter alloc] init];
    
    // Preview color movie
    self.previewColorMovie = [[GPUImageMovie alloc] initWithURL:self.colorUrl];
    self.previewColorMovie.playAtActualSpeed = YES;
    self.previewColorMovie.shouldRepeat = YES;
    [self.previewColorMovie addTarget:self.previewFilter];
    
    // Preview mask movie
    self.previewMaskMovie = [[GPUImageMovie alloc] initWithURL:self.maskUrl];
    self.previewMaskMovie.playAtActualSpeed = YES;
    self.previewMaskMovie.shouldRepeat = YES;
    [self.previewMaskMovie addTarget:self.previewFilter];
    
    [self.previewFilter addTarget:self.previewVideoView];
    
    [self.previewColorMovie startProcessing];
    [self.previewMaskMovie startProcessing];
}

- (void)initViews {
    
    // Background View
    self.backgroundView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_backgroundView];
    
    // Preview Video
    self.previewVideoView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.previewVideoView.backgroundColor = [UIColor clearColor];
    self.previewVideoView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:_previewVideoView];
}

- (void)initTopView {
    
    // TopView
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUSBAR_HEIGHT + 44.f)];
    [self.view addSubview:_topView];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _topView.bounds;
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.30].CGColor,
                             (__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.00].CGColor];
    gradientLayer.locations = @[@(0),@(1.0f)];
    [_topView.layer addSublayer:gradientLayer];
    
    // 返回
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.backgroundColor = [UIColor clearColor];
    btnBack.frame = CGRectMake(0, STATUSBAR_HEIGHT, 44.f, 44.f);
    [btnBack setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"icon_back_pressed"] forState:UIControlStateHighlighted];
    [_topView addSubview:btnBack];
    [btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 一键合成
    UIButton *btnVideoMaker = [UIButton buttonWithType:UIButtonTypeCustom];
    btnVideoMaker.backgroundColor = [UIColor redColor];
    [btnVideoMaker setTitle:@"一键合成" forState:UIControlStateNormal];
    [btnVideoMaker setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnVideoMaker.titleLabel.font = [UIFont systemFontOfSize:14];
    btnVideoMaker.layer.cornerRadius = 16;
    btnVideoMaker.clipsToBounds = YES;
    [_topView addSubview:btnVideoMaker];
    [btnVideoMaker addTarget:self action:@selector(videoMakerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnVideoMaker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.bottom.equalTo(self.topView.mas_bottom).offset(-6);
        make.width.equalTo(@100);
        make.height.equalTo(@32);
    }];
}

- (void)initProgressView {
    
    self.displayLabel = [[UILabel alloc] init];
    _displayLabel.textColor = [UIColor redColor];
    _displayLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_displayLabel];
    
    [_displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-40);
        make.width.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    self.displayLabel2 = [[UILabel alloc] init];
    _displayLabel2.textColor = [UIColor redColor];
    _displayLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_displayLabel2];
    
    [_displayLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@40);
    }];
}

- (void)updateProgress {
    
    self.displayLabel.text = [NSString stringWithFormat:@"Progress:%d%%", (int)(self.maskColorMovie.progress * 100)];
    self.displayLabel2.text = [NSString stringWithFormat:@"Progress:%d%%", (int)(self.srcMovie.progress * 100)];
}

@end
