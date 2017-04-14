//
//  PosterCollectionViewController.m
//  UICollectionViewDemo
//
//  Created by leihui on 2017/4/13.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "PosterCollectionViewController.h"
#import "PosterCollectionViewCell.h"
#import "DDCollectionViewFlowLayout.h"
#import "MJRefresh.h"

static NSString *kCellIdentifier = @"cellIdentifier";

@interface PosterCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, DDCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DDCollectionViewFlowLayout *layout;
@property (nonatomic, assign) NSInteger numberOfColumns;

@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSMutableArray *arrayImage;
@property (nonatomic, strong) NSMutableArray *arrayImageSize;

@end

@implementation PosterCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if (SYSTEM_VERSION >= 7.0) {
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
			[self setEdgesForExtendedLayout:UIRectEdgeNone];
		}
	}
	
	self.title = @"Poster";
	self.view.backgroundColor = [UIColor whiteColor];
	
	_numberOfColumns = 2;
	
	self.posterPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resource/Images/Poster"];
	self.arrayImage = [NSMutableArray array];
	self.arrayImageSize = [NSMutableArray array];
	
	[self createCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)reloadData
{
	if ([_arrayImage count] > 0) {
		[_arrayImage removeAllObjects];
	}
	
	if ([_arrayImageSize count] > 0) {
		[_arrayImageSize removeAllObjects];
	}
	
	[self loadData];
	
	[_collectionView reloadData];
	[_collectionView.mj_header endRefreshing];
}

- (void)loadMoreData
{
	[self loadData];
	
	[_collectionView reloadData];
	[_collectionView.mj_footer endRefreshing];
}

- (void)loadData
{
	NSString *singlePath = [_posterPath stringByAppendingPathComponent:@"1"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:singlePath]) {
		NSArray *contents = [fileManager contentsOfDirectoryAtPath:singlePath error:NULL];
		for (NSString *folderName in contents) {
			NSString *folderPath = [singlePath stringByAppendingPathComponent:folderName];
			NSString *filePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", folderName]];
			if ([fileManager fileExistsAtPath:filePath]) {
				UIImage *image = [UIImage imageWithContentsOfFile:filePath];
				if (image) {
					[_arrayImage addObject:image];
					[_arrayImageSize addObject:NSStringFromCGSize(image.size)];
				}
			}
		}
	}
}

- (void)createCollectionView
{
	CGRect frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, kAppView_Height);
	
	self.layout = [[DDCollectionViewFlowLayout alloc] init];
	_layout.delegate = self;
	
	self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:_layout];
	_collectionView.backgroundColor = [UIColor clearColor];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.showsVerticalScrollIndicator = NO;
	_collectionView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:_collectionView];
	
	[_collectionView registerClass:[PosterCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
	
	__block __typeof(self) weakSelf = self;
	// 下拉刷新
	_collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[weakSelf performSelector:@selector(reloadData) withObject:nil afterDelay:1.f];
	}];
	[_collectionView.mj_header beginRefreshing];
	
	// 上拉刷新
	_collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		[weakSelf performSelector:@selector(loadMoreData) withObject:nil afterDelay:1.f];
	}];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [_arrayImage count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(DDCollectionViewFlowLayout *)layout numberOfColumnsInSection:(NSInteger)section
{
	return _numberOfColumns;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PosterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
	if (cell) {
		cell.backgroundColor = [UIColor clearColor];
		NSInteger row = indexPath.row;
		if (row < [_arrayImage count]) {
			UIImage *image = _arrayImage[row];
			[cell updateWithImage:image];
		}
	}
	
	return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return 5.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	return 5.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = indexPath.row;
	if (row < [_arrayImageSize count]) {
		CGSize size = CGSizeFromString(_arrayImageSize[row]);
		
		CGFloat leftRightMargin = _layout.sectionInset.left + _layout.sectionInset.right;
		CGFloat xIntervalSpace = _layout.minimumLineSpacing * (_numberOfColumns - 1);
		
		CGFloat width = (SCREEN_WIDTH - leftRightMargin - xIntervalSpace) / _numberOfColumns;
		CGFloat height = width*size.height/size.width;
		
		return CGSizeMake(width, height);
	}
	return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Selected Row:%zd", indexPath.row);
}

@end
