//
//  DemoCollectionViewController.m
//  UICollectionViewDemo
//
//  Created by leihui on 17/3/22.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "DemoCollectionViewController.h"
#import "DemoViewCell.h"
#import "MJRefresh.h"
#import "DataRequestManager.h"

#define kPageSize		20

static NSString *kCellIdentifier = @"cellIdentifier";

@interface DemoCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation DemoCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if (SYSTEM_VERSION >= 7.0) {
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
			[self setEdgesForExtendedLayout:UIRectEdgeNone];
		}
	}
	
	self.title = @"CollectionView Demo";
	self.view.backgroundColor = [UIColor whiteColor];
	
	_pageIndex = 0;
	self.arrayData = [NSMutableArray array];
	
	[self requestData];
	[self createCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)reRequestData
{
	_pageIndex = 0;
	[_arrayData removeAllObjects];
	[self requestData];
}

- (void)requestData
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	__block __typeof(self) weakSelf = self;
	[[DataRequestManager sharedInstance] requestDataWithResType:TypeIdCollage
													  pageIndex:++_pageIndex
													   pageSize:kPageSize
														   webp:0
													 successful:^(id responseObject) {
														 NSLog(@"");
														 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
														 [weakSelf.collectionView.mj_header endRefreshing];
														 [weakSelf.collectionView.mj_footer endRefreshing];
														 
														 [weakSelf parseData:responseObject];
													 } failed:^(NSError *error) {
														 NSLog(@"failed");
													 }];
}

- (void)parseData:(id)responseObject
{
	if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
		NSArray *list = responseObject[@"PicList"];
		for (NSDictionary *dict in list) {
			DemoItem *item = [DemoItem yy_modelWithDictionary:dict];
			if (item) {
				[_arrayData addObject:item];
			}
		}
		[_collectionView reloadData];
	}
}

- (void)createCollectionView
{
	CGRect frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, kAppView_Height);
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	layout.itemSize = CGSizeMake(154.f*iPhoneWidthScaleFactor, 221.f*iPhoneWidthScaleFactor);
	layout.sectionInset = UIEdgeInsetsMake(4.f*iPhoneWidthScaleFactor, 4.f*iPhoneWidthScaleFactor, 4.f*iPhoneWidthScaleFactor, 4.f*iPhoneWidthScaleFactor);
	layout.minimumLineSpacing = 2.f*iPhoneWidthScaleFactor;
	layout.minimumInteritemSpacing = 2.f*iPhoneWidthScaleFactor;
	
	self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
	_collectionView.backgroundColor = [UIColor clearColor];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.showsVerticalScrollIndicator = NO;
	_collectionView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:_collectionView];
	
	[_collectionView registerClass:[DemoViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
	
	__block __typeof(self) weakSelf = self;
	
	// 下拉刷新
	_collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[weakSelf.collectionView.mj_header beginRefreshing];
		[weakSelf reRequestData];
	}];
	
	// 设置自动切换透明度(在导航栏下面自动隐藏)
	_collectionView.mj_header.automaticallyChangeAlpha = YES;
	
	// 上拉刷新
	_collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		[weakSelf requestData];
	}];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [_arrayData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	DemoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
	if (cell) {
		NSInteger row = indexPath.row;
		if (row < [_arrayData count]) {
			DemoItem *item = _arrayData[row];
			[cell updateWithItem:item];
		}
	}
	
	return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = indexPath.row;
	if (row < [_arrayData count]) {
		DemoItem *item = _arrayData[row];
	}
}

@end
