//
//  SimpleRollCollectionViewCtrl.m
//  UICollectionViewDemo
//
//  Created by leihui on 17/1/4.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "SimpleRollCollectionViewCtrl.h"
#import "SimpleRollLayout.h"

static NSString *kCellIdentifier = @"cellIdentifier";

@interface SimpleRollCollectionViewCtrl () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SimpleRollCollectionViewCtrl

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
	CGRect frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, 400);
	
	SimpleRollLayout *layout = [[SimpleRollLayout alloc] init];
	
	self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
	_collectionView.backgroundColor = [UIColor clearColor];
	_collectionView.dataSource = self;
	_collectionView.delegate = self;
	_collectionView.showsVerticalScrollIndicator = NO;
	_collectionView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:_collectionView];
	
	_collectionView.contentOffset = CGPointMake(0, 400);
	
	[_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
	cell.backgroundColor = kRandomColor;
	
	NSString *strText = [NSString stringWithFormat:@"我是第%zd行", indexPath.row];
	UIFont *font = [UIFont systemFontOfSize:14.f];
	UIColor *color = [UIColor orangeColor];
	CGRect frame = CGRectMake(0, 0, 250.f, 80.f);
	
	UILabel *label = [UILabel labelWithName:strText font:font frame:frame color:color alignment:NSTextAlignmentCenter];
	[cell.contentView addSubview:label];
	
	return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView.contentOffset.y < 200) {
		scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y+10*400);
	}
	else if (scrollView.contentOffset.y > 11*400) {
		scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y-10*400);
	}
}

@end
