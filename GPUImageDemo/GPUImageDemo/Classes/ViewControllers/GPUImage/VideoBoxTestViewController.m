//
//  VideoBoxTestViewController.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/25.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "VideoBoxTestViewController.h"
#import "WAVideoBox.h"

@interface VideoBoxTestViewController ()

@property (nonatomic, strong) NSString *videoUrl1;
@property (nonatomic, strong) NSString *videoUrl2;
@property (nonatomic, strong) WAVideoBox *videoBox;

@end

@implementation VideoBoxTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.videoUrl1 = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
    
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.mp4"];
    
    self.videoBox = [[WAVideoBox alloc] init];
    _videoBox.ratio = WAVideoExportRatio1280x720;
    
    [_videoBox appendVideoByPath:_videoUrl1];
    [_videoBox appendVideoByPath:_videoUrl1];
    [_videoBox appendVideoByPath:_videoUrl1];
    [_videoBox rangeVideoByTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(3000, 600))];
    
    [_videoBox asyncFinishEditByFilePath:filePath
                                progress:^(float progress) {
        NSLog(@"progress:%@", @(progress));
    } complete:^(NSError *error) {
        NSLog(@"complete:%@", error);
    }];
}

@end
