//
//  ViewController.m
//  GPUImageDemo
//
//  Created by leihui on 17/3/14.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "VPDIYPreviewViewController.h"

#import "GPUImageViewController01.h"
#import "GPUImageViewController02.h"
#import "GPUImageViewController03.h"

#import "GPUImageViewController001.h"
#import "GPUImageViewController002.h"
#import "GPUImageViewController003.h"
#import "GPUImageViewController004.h"
#import "GPUImageViewController005.h"
#import "GPUImageViewController006.h"
#import "GPUImageViewController007.h"
#import "GPUImageViewController008.h"

#import "GPUImageViewBlendViewController.h"
#import "GPUImageViewImageBlendViewController.h"
#import "GPUImageViewTransparentViewController.h"
#import "GPUImageMovieWriterViewController.h"

#import "VideoBoxTestViewController.h"
#import "PictureMovieBlendViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *arrayData;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
		[self setEdgesForExtendedLayout:UIRectEdgeNone];
	}
	
	self.title = @"Demos";
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
	self.arrayData = @[@[@"Test", [TestViewController class]],
                       @[@"DIY", [VPDIYPreviewViewController class]],
                       
                       @[@"GPUImage 01", [GPUImageViewController01 class]],
					   @[@"GPUImage 02", [GPUImageViewController02 class]],
					   @[@"GPUImage 03", [GPUImageViewController03 class]],
                       
                       @[@"GPUImage 001", [GPUImageViewController001 class]],
                       @[@"GPUImage 002", [GPUImageViewController002 class]],
                       @[@"GPUImage 003", [GPUImageViewController003 class]],
                       @[@"GPUImage 004", [GPUImageViewController004 class]],
                       @[@"GPUImage 005", [GPUImageViewController005 class]],
                       @[@"GPUImage 006", [GPUImageViewController006 class]],
                       @[@"GPUImage 007", [GPUImageViewController007 class]],
                       @[@"GPUImage 008", [GPUImageViewController008 class]],
                       
                       @[@"GPUImage Blend", [GPUImageViewBlendViewController class]],
                       @[@"GPUImage ImageBlend", [GPUImageViewImageBlendViewController class]],
                       @[@"GPUImage Transparent", [GPUImageViewTransparentViewController class]],
                       @[@"GPUImage MovieWriter", [GPUImageMovieWriterViewController class]],
                       @[@"Video Box Test", [VideoBoxTestViewController class]],
                       @[@"Picture Movie Blend", [PictureMovieBlendViewController class]],
					   ];
}

- (void)createTableView
{
	CGRect tableViewFrame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, APP_VIEW_HEIGHT);
	
	self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	_tableView.showsHorizontalScrollIndicator = NO;
	_tableView.showsVerticalScrollIndicator = YES;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	
	if (row < [_arrayData count]) {
		cell.textLabel.text = [_arrayData[row] firstObject];
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

@end
