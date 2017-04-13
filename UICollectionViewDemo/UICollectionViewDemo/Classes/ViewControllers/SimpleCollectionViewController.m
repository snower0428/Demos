//
//  SimpleCollectionViewController.m
//  UICollectionViewDemo
//
//  Created by leihui on 17/1/4.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "SimpleCollectionViewController.h"

static NSString *kCellIdentifier = @"cellIdentifier";

@interface SimpleCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SimpleCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if (SYSTEM_VERSION >= 7.0) {
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
			[self setEdgesForExtendedLayout:UIRectEdgeNone];
		}
	}
	
	self.title = @"Simple Collection";
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self createCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)createCollectionView
{
	CGRect frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, kAppView_Height);
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	layout.itemSize = CGSizeMake(100.f, 100.f);
	
	NSLog(@"sectionInset:%@", NSStringFromUIEdgeInsets(layout.sectionInset));
	NSLog(@"minimumLineSpacing:%f", layout.minimumLineSpacing);
	NSLog(@"minimumInteritemSpacing:%f", layout.minimumInteritemSpacing);
	
	self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
	_collectionView.backgroundColor = [UIColor clearColor];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.showsVerticalScrollIndicator = NO;
	_collectionView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:_collectionView];
	
	[_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
	cell.backgroundColor = kRandomColor;
	
	return cell;
}

@end
