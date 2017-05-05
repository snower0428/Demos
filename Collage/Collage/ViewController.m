//
//  ViewController.m
//  Collage
//
//  Created by leihui on 17/3/14.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "PHImagePickerViewCtrl.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, PHImagePickerViewCtrlDelegate>

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
#if 0
		UIViewController *ctrl = [[_arrayData[row] lastObject] new];
		[self.navigationController pushViewController:ctrl animated:YES];
#else
		PHImagePickerViewCtrl *imagePickerController = [[PHImagePickerViewCtrl alloc] init];
		imagePickerController.delegate = self;
		imagePickerController.allowsMultipleSelection = YES;
		
		[self.navigationController pushViewController:imagePickerController animated:YES];
#endif
	}
}

#pragma mark - PHImagePickerViewCtrlDelegate

- (void)imagePickerController:(PHImagePickerViewCtrl *)imagePickerController collageImage:(UIImage *)image
{
	NSLog(@"");
}

@end
