//
//  PictureMovieBlendViewController.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/25.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "PictureMovieBlendViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface PictureMovieBlendViewController ()

@property (nonatomic, strong) NSURL *maskMovieURL;

@property (nonatomic, strong) GPUImageChromaKeyBlendFilter *blendFilter;

@property (nonatomic, strong) GPUImageMovie *pictureMaskMovie;
@property (nonatomic, strong) GPUImageMovieWriter *pictureMovieWriter;
@property (nonatomic, strong) GPUImagePicture *picture;

@end

@implementation PictureMovieBlendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.maskMovieURL = [[NSBundle mainBundle] URLForResource:@"MaskMovie1" withExtension:@"m4v"];
    
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

@end
