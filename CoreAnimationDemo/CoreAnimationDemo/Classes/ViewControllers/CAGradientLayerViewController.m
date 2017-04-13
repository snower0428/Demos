//
//  CAGradientLayerViewController.m
//  TempDemo
//
//  Created by leihui on 17/3/14.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "CAGradientLayerViewController.h"

@interface CAGradientLayerViewController ()

@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) UIImageView *layerView1;
@property (nonatomic, strong) UIImageView *layerView2;

@property (nonatomic, strong) UIImageView *outerLayer;
@property (nonatomic, strong) UIImageView *innerLayer;

@end

@implementation CAGradientLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self createSimpleColorLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)createSimpleColorLayer
{
	CAGradientLayer *colorLayer = [CAGradientLayer layer];
	colorLayer.frame = CGRectMake(0, 0, 200, 200);
	colorLayer.center = self.view.center;
	[self.view.layer addSublayer:colorLayer];
	
	// 颜色分配
	colorLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
						  (__bridge id)[UIColor greenColor].CGColor,
						  (__bridge id)[UIColor blueColor].CGColor];
	// 颜色分割线
	colorLayer.locations = @[@(0.25), @(0.5), @(0.75)];
	// 起始点
	colorLayer.startPoint = CGPointMake(0, 0);
	// 结束点
	colorLayer.endPoint = CGPointMake(1, 0);
}

- (void)testCode
{
#if 0
	CGFloat width = 200.f;
	CGFloat height = 300.f;
	CGRect frame = CGRectMake(0.f, 0.f, width, height);
	
	self.layerView1 = [[UIImageView alloc] initWithFrame:frame];
	_layerView1.image = getResource(@"test.jpg");
	_layerView1.center = self.view.center;
	[self.view addSubview:_layerView1];
	
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = -1.0/500.0;
	transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
	_layerView1.layer.transform = transform;
	//_layerView1.layer.doubleSided = NO;
#endif
	
#if 0
	CGFloat width = 150.f;
	CGFloat height = 225.f;
	CGRect frame = CGRectMake(0.f, 0.f, width, height);
	
	self.containerView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_containerView];
	
	self.layerView1 = [[UIImageView alloc] initWithFrame:frame];
	_layerView1.image = getResource(@"test.jpg");
	_layerView1.center = CGPointMake(SCREEN_WIDTH/4, SCREEN_HEIGHT/2);
	[_containerView addSubview:_layerView1];
	
	self.layerView2 = [[UIImageView alloc] initWithFrame:frame];
	_layerView2.image = getResource(@"test.jpg");
	_layerView2.center = CGPointMake(SCREEN_WIDTH*3/4, SCREEN_HEIGHT/2);
	[_containerView addSubview:_layerView2];
	
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = -1.0/500.0;
	_containerView.layer.sublayerTransform = transform;
	
	CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
	_layerView1.layer.transform = transform1;
	
	CATransform3D transform2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
	_layerView2.layer.transform = transform2;
#endif
	
#if 0
	CGFloat width = 300.f;
	CGFloat height = 300.f;
	CGRect frame = CGRectMake(0.f, 0.f, width, height);
	
	self.outerLayer = [[UIImageView alloc] initWithFrame:frame];
	_outerLayer.backgroundColor = [UIColor orangeColor];
	_outerLayer.center = self.view.center;
	[self.view addSubview:_outerLayer];
	
	width = 150.f;
	height = 150.f;
	frame = CGRectMake(0.f, 0.f, width, height);
	
	self.innerLayer = [[UIImageView alloc] initWithFrame:frame];
	_innerLayer.backgroundColor = [UIColor blueColor];
	_innerLayer.center = CGPointMake(CGRectGetWidth(_outerLayer.frame)/2, CGRectGetHeight(_outerLayer.frame)/2);
	[_outerLayer addSubview:_innerLayer];
	
	CATransform3D transform1 = CATransform3DIdentity;
	transform1.m34 = -1.0/500.0;
	transform1 = CATransform3DRotate(transform1, M_PI_4, 0, 1, 0);
	_outerLayer.layer.transform = transform1;
	
	CATransform3D transform2 = CATransform3DIdentity;
	transform2.m34 = -1.0/500.0;
	transform2 = CATransform3DRotate(transform2, -M_PI_4, 0, 1, 0);
	_innerLayer.layer.transform = transform2;
#endif
}

@end
