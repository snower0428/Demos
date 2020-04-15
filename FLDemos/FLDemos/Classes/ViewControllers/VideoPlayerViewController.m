//
//  TestViewController.m
//  FLDemos
//
//  Created by leihui on 17/3/14.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <JPVideoPlayer/JPVideoPlayerKit.h>

@interface VideoPlayerViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thridImageView;

@property (nonatomic, assign) CGFloat scrollViewOffsetYOnStartDrag;

@property (nonatomic, strong) NSArray<NSString *> *videoStrings;
@property (nonatomic, assign) NSUInteger currentVideoIndex;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor orangeColor];
    self.currentVideoIndex = 0;
    
//    [self.navigationController setNavigationBarHidden:YES];
    
    // 一行代码搞定导航栏透明度
    [self wr_setNavBarBackgroundAlpha:0.f];
    // 一行代码搞定导航栏两边按钮颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    // 一行代码搞定状态栏是 default 还是 lightContent
    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self initViews];
    
    self.scrollView.contentInset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollViewOffsetYOnStartDrag = -100;
    [self scrollViewDidEndScrolling];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.secondImageView jp_stopPlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.scrollViewOffsetYOnStartDrag = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self scrollViewDidEndScrolling];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrolling];
}

#pragma mark - Private

- (void)scrollViewDidEndScrolling {
    NSLog(@"scrollViewOffsetYOnStartDrag:%@, self.scrollView.contentOffset.y:%@",
          @(_scrollViewOffsetYOnStartDrag), @(self.scrollView.contentOffset.y));
    if (self.scrollViewOffsetYOnStartDrag == self.scrollView.contentOffset.y) {
        return;
    }
    
    [self.scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT) animated:NO];
    [self.secondImageView jp_stopPlay];
    [self.secondImageView jp_playVideoMuteWithURL:[self fetchURL]
                               bufferingIndicator:nil
                                     progressView:nil
                                    configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
        view.jp_muted = NO;
    }];
}

- (NSURL *)fetchURL {
    if (self.currentVideoIndex == self.videoStrings.count - 1) {
        self.currentVideoIndex = 0;
    }
    NSURL *url = [NSURL URLWithString:self.videoStrings[self.currentVideoIndex]];
    self.currentVideoIndex++;
    return url;
}

- (NSArray<NSString *> *)videoStrings {
    if (!_videoStrings) {
        _videoStrings = @[
            @"http://res.ifjing.com/video/2020/02/05/r_2808280/1/preav_2808280_01.mp4",
            @"http://res.ifjing.com/video/2020/02/05/r_2808279/1/preav_2808279_01.mp4",
            @"http://res.ifjing.com/video/2020/02/04/r_2808275/1/preav_2808275_01.mp4",
            @"http://res.ifjing.com/video/2020/02/04/r_2808276/1/preav_2808276_01.mp4",
            @"http://res.ifjing.com/video/2020/02/03/r_2808272/1/preav_2808272_01.mp4",
            @"http://res.ifjing.com/video/2020/02/04/r_2808273/1/av_c8e47a5474fd4fc42808273_01.mp4",
            @"http://res.ifjing.com/video/2020/02/02/r_2808266/1/preav_2808266_01.mp4",
            @"http://res.ifjing.com/video/2020/02/03/r_2808268/1/av_26e14f96c3a699d22808268_01.mp4",
            @"http://res.ifjing.com/video/2020/01/31/r_2808259/1/preav_2808259_01.mp4",
            @"http://res.ifjing.com/video/2020/02/05/r_2808277/1/av_5b3a90174951e3702808277_01.mp4",
            @"http://res.ifjing.com/video/2020/01/29/r_2808253/1/av_b4896d0340d88adf2808253_01.mp4",
            @"http://res.ifjing.com/video/2020/02/02/r_2808265/1/av_e471cd826a4d15c92808265_01.mp4",
            @"http://res.ifjing.com/video/2020/01/30/r_2808256/1/av_b4b9d99ce80c9f392808256_01.mp4",
            @"http://res.ifjing.com/video/2020/02/05/r_2808278/1/av_3c5e89b596dc7c182808278_01.mp4",
            @"http://res.ifjing.com/video/2020/01/29/r_2808249/1/av_73ba29eaa7cfd0172808249_01.mp4",
            @"http://res.ifjing.com/video/2020/02/03/r_2808269/1/preav_2808269_01.mp4",
        ];
    }
    return _videoStrings;
}

- (void)initViews {
    self.scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.frame = self.view.bounds;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 3);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    
    self.firstImageView = [[UIImageView alloc] init];
    _firstImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _firstImageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_firstImageView];
    
    self.secondImageView = [[UIImageView alloc] init];
    _secondImageView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    _secondImageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_secondImageView];
    
    self.thridImageView = [[UIImageView alloc] init];
    _thridImageView.frame = CGRectMake(0, SCREEN_HEIGHT * 2, SCREEN_WIDTH, SCREEN_HEIGHT);
    _thridImageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_thridImageView];
}

@end
