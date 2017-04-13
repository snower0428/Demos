//
//  ViewController.m
//  UICollectionViewDemo
//
//  Created by leihui on 16/12/21.
//  Copyright © 2016年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"
#import "PosterCollectionViewController.h"
#import "DemoCollectionViewController.h"
#import "SimpleCollectionViewController.h"
#import "SimpleWaterfallCollectionViewCtrl.h"
#import "SimpleCircleCollectionViewCtrl.h"
#import "SimpleRollCollectionViewCtrl.h"
#import "LineCollectionViewController.h"

#define kCellRowHeight				(50.0f*iPhoneWidthScaleFactor)

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *arrayData;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	if (SYSTEM_VERSION >= 7.0) {
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
			[self setEdgesForExtendedLayout:UIRectEdgeNone];
		}
	}
	
	self.title = @"Collection";
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self configureTableView];
	[self createTableView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)configureTableView
{
	self.arrayData = @[@[@"Poster", [PosterCollectionViewController class]],
					   @[@"CollectionView Demo", [DemoCollectionViewController class]],
					   @[@"Simple CollectionView", [SimpleCollectionViewController class]],
					   @[@"Simple Waterfall", [SimpleWaterfallCollectionViewCtrl class]],
					   @[@"Simple Circle", [SimpleCircleCollectionViewCtrl class]],
					   @[@"Simple Roll", [SimpleRollCollectionViewCtrl class]],
					   ];
}

- (void)createTableView
{
	CGRect tableViewFrame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, kAppView_Height);
	
	self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	_tableView.showsHorizontalScrollIndicator = NO;
	_tableView.showsVerticalScrollIndicator = NO;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_arrayData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"cellIdentifier";
	
	NSInteger row = indexPath.row;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		
		// Separator
		UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0.f, kCellRowHeight-1.f, SCREEN_WIDTH, 1.f)];
		separator.backgroundColor = RGB(227, 227, 227);
		[cell.contentView addSubview:separator];
	}
	
	if (row < [_arrayData count]) {
		NSArray *array = _arrayData[row];
		cell.textLabel.text = array[0];
	}
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSInteger row = indexPath.row;
	if (row < [_arrayData count]) {
		UIViewController *ctrl = [[_arrayData[row] lastObject] new];
		[self.navigationController pushViewController:ctrl animated:YES];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kCellRowHeight;
}

@end
