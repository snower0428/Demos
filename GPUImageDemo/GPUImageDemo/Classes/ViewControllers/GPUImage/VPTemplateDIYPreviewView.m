//
//  VPTemplateDIYPreviewView.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/19.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "VPTemplateDIYPreviewView.h"
#import "VPGPUImageMovie.h"
#import "XGPUImageMovie.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface VPTemplateDIYPreviewView ()

@property (nonatomic, strong) GPUImageView *backgroundView;
@property (nonatomic, strong) GPUImageView *videoView;

@property (nonatomic, strong) NSURL *backgroundMovieURL;
@property (nonatomic, strong) VPGPUImageMovie *backgroundMovie;

@property (nonatomic, strong) NSURL *colorUrl;
@property (nonatomic, strong) NSURL *maskUrl;
@property (nonatomic, strong) GPUImageMaskFilter *filter;
@property (nonatomic, strong) VPGPUImageMovie *imageMovieColor;
@property (nonatomic, strong) VPGPUImageMovie *imageMovieMask;

@property (nonatomic, strong) NSString *maskMoviePath;
@property (nonatomic, strong) NSURL *maskMovieURL;
@property (nonatomic, strong) GPUImageMovieWriter *maskMovieWriter;

@property (nonatomic, strong) GPUImageAlphaBlendFilter *blendFilter;
@property (nonatomic, strong) GPUImageMovie *srcMovie;
@property (nonatomic, strong) GPUImageMovie *finalMovie;
@property (nonatomic, strong) GPUImageMovieWriter *finalMovieWriter;

@property (nonatomic, strong) UILabel *displayLabel;

@end

@implementation VPTemplateDIYPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // Init
        [self initViews];
        
        [self setupConfigurations];
        [self setupBackgroundMovie];
        [self setupForegroundMovie];
        [self setupMaskMovieWriter];
        [self createProgressView];
        
        //进度显示
//        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
//        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//        [displayLink setPaused:NO];
    }
    return self;
}

#pragma mark - Public

- (void)process {

}

- (void)saveFinalMovieComplete:(void(^)(void))complete {
    
    self.blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    [self.blendFilter setMix:0.8];
    
    self.srcMovie = [[GPUImageMovie alloc] initWithURL:self.backgroundMovieURL];
    self.srcMovie.playAtActualSpeed = YES;
    [self.srcMovie addTarget:self.blendFilter];
    
    self.finalMovie = [[GPUImageMovie alloc] initWithURL:self.maskMovieURL];
    self.finalMovie.playAtActualSpeed = YES;
    [self.finalMovie addTarget:self.blendFilter];
    
    [self.srcMovie startProcessing];
    [self.finalMovie startProcessing];
    
    // Final movie
    NSString *finalMoviePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FinalMovie.m4v"];
    unlink([finalMoviePath UTF8String]);
    NSURL *finalMovieUrl = [NSURL fileURLWithPath:finalMoviePath];
    
    // Final movie writer
    self.finalMovieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:finalMovieUrl size:CGSizeMake(720, 1280)];
    // 使用源音源
//    self.finalMovieWriter.shouldPassthroughAudio = YES;
    
    [self.blendFilter addTarget:self.finalMovieWriter];
//    self.blendFilter.audioEncodingTarget = self.finalMovieWriter;
    [self.finalMovieWriter startRecording];
    
    kWeakSelf;
    [self.finalMovieWriter setCompletionBlock:^{
        [weakSelf.blendFilter removeTarget:weakSelf.finalMovieWriter];
//        weakSelf.blendFilter.audioEncodingTarget = nil;
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

#pragma mark - Private

- (void)setupConfigurations {
    
    // 视频url配置
    self.backgroundMovieURL = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"];
    self.colorUrl = [[NSBundle mainBundle] URLForResource:@"color0" withExtension:@"mp4"];
    self.maskUrl = [[NSBundle mainBundle] URLForResource:@"mask0" withExtension:@"mp4"];
}

- (void)setupBackgroundMovie {
    
    // Background movie
    self.backgroundMovie = [[VPGPUImageMovie alloc] initWithURL:self.backgroundMovieURL];
    self.backgroundMovie.playSound = YES;
    self.backgroundMovie.playAtActualSpeed = YES;
    [self.backgroundMovie addTarget:self.backgroundView];
    
    [self.backgroundMovie startProcessing];
}

- (void)setupForegroundMovie {
    
    self.filter = [[GPUImageMaskFilter alloc] init];
    
    // Color movie
    self.imageMovieColor = [[VPGPUImageMovie alloc] initWithURL:self.colorUrl];
    self.imageMovieColor.playSound = YES;
    self.imageMovieColor.playAtActualSpeed = YES;
    [self.imageMovieColor addTarget:self.filter];
    
    // Mask movie
    self.imageMovieMask = [[VPGPUImageMovie alloc] initWithURL:self.maskUrl];
    self.imageMovieMask.playAtActualSpeed = YES;
    [self.imageMovieMask addTarget:self.filter];
    
    [self.filter addTarget:self.videoView];
}

- (void)setupMaskMovieWriter {
    
    // Mask movie
    NSString *maskMoviePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MaskMovie.m4v"];
    unlink([maskMoviePath UTF8String]);
    self.maskMoviePath = maskMoviePath;
    NSURL *maskMovieURL = [NSURL fileURLWithPath:maskMoviePath];
    self.maskMovieURL = maskMovieURL;
    
    // Mask movie writer
    self.maskMovieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:maskMovieURL size:CGSizeMake(720, 1280)];
    self.maskMovieWriter.encodingLiveVideo = NO;
    // 使用源音源
    self.maskMovieWriter.shouldPassthroughAudio = YES;
    
    self.imageMovieColor.audioEncodingTarget = _maskMovieWriter;
    
    [self.filter addTarget:_maskMovieWriter];
    
    [self.imageMovieColor startProcessing];
    [self.imageMovieMask startProcessing];
    [self.maskMovieWriter startRecording];
    
    kWeakSelf;
    [self.maskMovieWriter setCompletionBlock:^{
        [weakSelf.filter removeTarget:weakSelf.maskMovieWriter];
        weakSelf.imageMovieColor.audioEncodingTarget = nil;
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
                     }
                 });
             }];
        }
    }];
}

- (void)initViews {
    
    // BackgroundView
    self.backgroundView = [[GPUImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_backgroundView];
    
    self.videoView = [[GPUImageView alloc] initWithFrame:self.bounds];
    self.videoView.backgroundColor = [UIColor clearColor];
    self.videoView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self addSubview:_videoView];
}

- (void)createProgressView {
    
    self.displayLabel = [[UILabel alloc] init];
    _displayLabel.textColor = [UIColor whiteColor];
    _displayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_displayLabel];
    
    [_displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@40);
    }];
}

- (void)updateProgress {
    
    self.displayLabel.text = [NSString stringWithFormat:@"Progress:%d%%", (int)(self.imageMovieColor.progress * 100)];
}

@end
