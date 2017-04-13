//
//  GPUImageViewController01.m
//  GPUImageDemo
//
//  Created by leihui on 17/4/11.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewController01.h"
#import <GPUImage/GPUImageSepiaFilter.h>

@interface GPUImageViewController01 ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GPUImageViewController01

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self createNavigationItem];
	
	UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	bgView.image = getResource(@"test01.jpg");
	[self.view addSubview:bgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)createNavigationItem
{
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction:)];
	self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Actions

- (void)rightAction:(id)sender
{
	if (_imageView) {
		[_imageView removeFromSuperview];
		self.imageView = nil;
		return;
	}
	self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_imageView];
	
	UIImage *image = getResource(@"test01.jpg");
	if (image) {
		GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
		image = [filter imageByFilteringImage:image];
		_imageView.image = image;
	}
}

@end
