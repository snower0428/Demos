//
//  CircleViewController.m
//  AnimationsDemo
//
//  Created by leihui on 17/3/2.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "CircleViewController.h"
#import "CircleView.h"

@interface CircleViewController ()

@property (nonatomic, strong) CircleView *circleView;

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self createCircleView];
	[self createSlider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)createCircleView
{
	CGRect frame = CGRectMake(0.f, 0.f, 200.f, 200.f);
	
	self.circleView = [[CircleView alloc] initWithFrame:frame];
	self.circleView.strokeColor = [UIColor customBlueColor];
	self.circleView.center = self.view.center;
	
	[self.view addSubview:self.circleView];
}

- (void)createSlider
{
	CGRect frame = CGRectMake(10.f, CGRectGetMaxY(self.circleView.frame)+30.f, SCREEN_WIDTH-20.f, 50.f);
	
	UISlider *slider = [[UISlider alloc] initWithFrame:frame];
	slider.backgroundColor = [UIColor clearColor];
	slider.value = 0.7f;
	slider.tintColor = [UIColor customBlueColor];
	[slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:slider];
	
	[self.circleView setStrokeEnd:slider.value animated:NO];
}

#pragma mark - Actions

- (void)sliderChanged:(UISlider *)slider
{
	[self.circleView setStrokeEnd:slider.value animated:YES];
}

@end
