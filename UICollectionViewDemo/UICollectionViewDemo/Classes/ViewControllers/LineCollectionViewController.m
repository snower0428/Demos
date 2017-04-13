//
//  LineCollectionViewController.m
//  UICollectionViewDemo
//
//  Created by leihui on 16/12/21.
//  Copyright © 2016年 ND WebSoft Inc. All rights reserved.
//

#import "LineCollectionViewController.h"
#import "ImageViewCell.h"
#import "LineLayout.h"

static NSString *kCellIdentifier = @"cellIdentifier";

@interface LineCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation LineCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if (SYSTEM_VERSION >= 7.0) {
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
			[self setEdgesForExtendedLayout:UIRectEdgeNone];
		}
	}
	
	self.title = @"Collection";
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self loadData];
	[self createCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[_collectionView reloadData];
}

#pragma mark - Private

- (void)loadData
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSInteger i = 0; i < 20; i++) {
		NSString *imageName = [NSString stringWithFormat:@"BackgroundImages/%02zd.jpg", i%16];
		UIImage *image = getResource(imageName);
		if (image) {
			[array addObject:image];
		}
	}
	self.dataArray = array;
}

- (void)createCollectionView
{
	CGRect frame = CGRectMake(0.f, 100.f, SCREEN_WIDTH, 200.f);
	
	LineLayout *layout = [[LineLayout alloc] init];
	layout.itemSize = CGSizeMake(100, 100);
	
	self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
	_collectionView.backgroundColor = [UIColor blackColor];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.showsVerticalScrollIndicator = NO;
	_collectionView.showsHorizontalScrollIndicator = NO;
	_collectionView.pagingEnabled = YES;
	[self.view addSubview:_collectionView];
	
	[_collectionView registerClass:[ImageViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [_dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"cellIdentifier";
	
	NSInteger row = indexPath.row;
	
	ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
	cell.backgroundColor = [UIColor clearColor];
	
	if (row < [_dataArray count]) {
		UIImage *image = _dataArray[row];
		[cell updateWithImage:image];
	}
	
	return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"row: %zd", indexPath.row);
}

@end
