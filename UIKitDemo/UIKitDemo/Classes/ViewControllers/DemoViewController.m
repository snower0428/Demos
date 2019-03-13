//
//  DemoViewController.m
//  UIKitDemo
//
//  Created by leihui on 2017/11/9.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.f, 200.f)];
	_imageView.backgroundColor = [UIColor orangeColor];
	[self.view addSubview:_imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	CGRect frame = CGRectMake(200, 400, 200, 200);
	[UIView animateWithDuration:1.0 animations:^{
		self.imageView.frame = frame;
	}];
}

#pragma mark - Private


#pragma mark - dealloc

- (void)dealloc
{
	NSLog(@"dealloc");
}

@end
