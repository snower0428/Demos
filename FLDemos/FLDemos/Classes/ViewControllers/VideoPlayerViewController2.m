//
//  VideoPlayerViewController2.m
//  FLDemos
//
//  Created by leihui on 2020/2/10.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "VideoPlayerViewController2.h"
#import <MJRefresh/MJRefresh.h>
#import "VideoDetailSectionModel.h"
#import "VideoSectionController.h"
#import "VideoCollectionViewCell.h"

@interface VideoPlayerViewController2 () <IGListAdapterDataSource, IGListAdapterPerformanceDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *listAdapter;
@property (nonatomic, strong) NSArray *dataLists;

@property (nonatomic, strong) NSArray<NSString *> *videoStrings;
@property (nonatomic, assign) NSUInteger currentVideoIndex;

@end

@implementation VideoPlayerViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    // 一行代码搞定导航栏透明度
    [self wr_setNavBarBackgroundAlpha:0.f];
    // 一行代码搞定导航栏两边按钮颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    // 一行代码搞定状态栏是 default 还是 lightContent
    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.dataLists = [NSArray array];
    
    [self CreateCollectionView];
    
    IGListAdapterUpdater *updater = [[IGListAdapterUpdater alloc] init];
    self.listAdapter = [[IGListAdapter alloc] initWithUpdater:updater viewController:self];
    _listAdapter.collectionView = self.collectionView;
    _listAdapter.dataSource = self;
    _listAdapter.performanceDelegate = self;
    
    [self loadData];
}

#pragma mark - Private

- (void)CreateCollectionView {
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:[UICollectionViewFlowLayout new]];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
    
    __weak __typeof(&*self)weakSelf = self;
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)loadData {
    
    NSMutableArray *arrayData = [NSMutableArray array];
    NSDictionary *dictRoot = [self jsonString];
    NSArray *array = dictRoot[@"ResList"];
    for (NSDictionary *dict in array) {
        NSString *previewUrl = dict[@"PreviewUrl"];
        NSArray *arrayUrl = [previewUrl componentsSeparatedByString:@"|"];
        VideoDetailItem *item = [VideoDetailItem new];
        if ([arrayUrl count] >= 2) {
            item.previewUrl = arrayUrl[0];
            item.videoUrl = arrayUrl[1];
        }
        [arrayData addObject:item];
    }
    
    VideoDetailSectionModel *sectionModel = [VideoDetailSectionModel new];
    sectionModel.arrayData = arrayData;
    self.dataLists = @[sectionModel];
    
    // 更新列表
    [self.listAdapter performUpdatesAnimated:YES completion:nil];
}

- (void)loadMoreData {
    
}

- (NSDictionary *)jsonString {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"video_detail" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return dict;
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

#pragma mark - IGListAdapterDataSource

- (NSArray<id <IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.dataLists;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    VideoSectionController *sectionController = [[VideoSectionController alloc] init];
    return sectionController;
}

- (nullable UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - IGListAdapterPerformanceDelegate <NSObject>

- (void)listAdapterWillCallDequeueCell:(IGListAdapter *)listAdapter {
    //NSLog(@"listAdapterWillCallDequeueCell");
}

- (void)listAdapter:(IGListAdapter *)listAdapter didCallDequeueCell:(UICollectionViewCell *)cell onSectionController:(IGListSectionController *)sectionController atIndex:(NSInteger)index {
    //NSLog(@"didCallDequeueCell index:%zd", index);
}

- (void)listAdapterWillCallDisplayCell:(IGListAdapter *)listAdapter {
    //NSLog(@"listAdapterWillCallDisplayCell");
}

- (void)listAdapter:(IGListAdapter *)listAdapter didCallDisplayCell:(UICollectionViewCell *)cell onSectionController:(IGListSectionController *)sectionController atIndex:(NSInteger)index {
    //NSLog(@"didCallDisplayCell index:%zd", index);
}

- (void)listAdapterWillCallEndDisplayCell:(IGListAdapter *)listAdapter {
    //NSLog(@"listAdapterWillCallEndDisplayCell");
}

- (void)listAdapter:(IGListAdapter *)listAdapter didCallEndDisplayCell:(UICollectionViewCell *)cell onSectionController:(IGListSectionController *)sectionController atIndex:(NSInteger)index {
    //NSLog(@"didCallEndDisplayCell index:%zd", index);
}

- (void)listAdapterWillCallSize:(IGListAdapter *)listAdapter {
    //NSLog(@"listAdapterWillCallSize");
}

- (void)listAdapter:(IGListAdapter *)listAdapter didCallSizeOnSectionController:(IGListSectionController *)sectionController atIndex:(NSInteger)index {
    //NSLog(@"didCallSizeOnSectionController index:%zd", index);
}

- (void)listAdapterWillCallScroll:(IGListAdapter *)listAdapter {
    //NSLog(@"listAdapterWillCallScroll");
}

- (void)listAdapter:(IGListAdapter *)listAdapter didCallScroll:(UIScrollView *)scrollView {
    //NSLog(@"didCallScroll");
}

@end
