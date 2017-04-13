//
//  PoppingViewController.m
//  AnimationsDemo
//
//  Created by leihui on 17/3/2.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "PoppingViewController.h"
#import "ButtonViewController.h"
#import "DecayViewController.h"
#import "CircleViewController.h"

static NSString *const kCellIdentifier = @"cellIdentifier";

@interface PoppingViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation PoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self configureTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)configureTableView
{
	self.items = @[@[@"Button Animation", [ButtonViewController class]],
				   @[@"Decay Animation", [DecayViewController class]],
				   @[@"Circle Animation", [CircleViewController class]],
				   ];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.rowHeight = 50.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSInteger row = indexPath.row;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
	if (cell) {
		if (row < [_items count]) {
			cell.textLabel.text = [_items[row] firstObject];
		}
	}
	
	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = indexPath.row;
	if (row < [_items count]) {
		UIViewController *ctrl = [[_items[row] lastObject] new];
		[self.navigationController pushViewController:ctrl animated:YES];
	}
}

@end
