//
//  TransformViewController.m
//  CoreAnimationDemo
//
//  Created by leihui on 17/3/15.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "TransformViewController.h"
#import <GLKit/GLKit.h>

#define LIGHT_DIRECTION		0, 1, -0.5
#define AMBIENT_LIGHT		0.5

@interface TransformViewController ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation TransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = RGB(240, 240, 240);
	
	self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_containerView];
	
	//[self createContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)createContentView
{
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = -1.0/500.0;
	transform = CATransform3DRotate(transform, -M_PI_4, 1, 0, 0);
	transform = CATransform3DRotate(transform, -M_PI_4, 0, 1, 0);
	_containerView.layer.sublayerTransform = transform;
	
	for (NSInteger i = 0; i < 6; i++) {
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 200.f)];
		view.backgroundColor = [UIColor whiteColor];
		view.center = _containerView.center;
		[_containerView addSubview:view];
		view.alpha = 0.f;
		view.userInteractionEnabled = NO;
		
		UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
		label.backgroundColor = [UIColor clearColor];
		label.text = [NSString stringWithFormat:@"%zd", i+1];
		label.textColor = [UIColor orangeColor];
		label.font = [UIFont systemFontOfSize:25.f];
		label.textAlignment = NSTextAlignmentCenter;
		[view addSubview:label];
		
		if (i == 2) {
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.frame = CGRectMake(50.f, 50.f, 100.f, 100.f);
			button.backgroundColor = [UIColor blueColor];
			[view addSubview:button];
			[button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
			
			view.userInteractionEnabled = YES;
		}
		
		if (i == 0) {
			transform = CATransform3DIdentity;
			transform = CATransform3DTranslate(transform, 0, 0, 100);
			view.layer.transform = transform;
			view.alpha = 1.f;
		}
		else if (i == 1) {
			transform = CATransform3DIdentity;
			transform = CATransform3DTranslate(transform, 100, 0, 0);
			transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
			view.layer.transform = transform;
			view.alpha = 1.f;
		}
		else if (i == 2) {
			transform = CATransform3DIdentity;
			transform = CATransform3DTranslate(transform, 0, -100, 0);
			transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
			view.layer.transform = transform;
			view.alpha = 1.f;
		}
		else if (i == 3) {
			transform = CATransform3DIdentity;
			transform = CATransform3DTranslate(transform, 0, 100, 0);
			transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
			view.layer.transform = transform;
			view.alpha = 1.f;
		}
		else if (i == 4) {
			transform = CATransform3DIdentity;
			transform = CATransform3DTranslate(transform, -100, 0, 0);
			transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
			view.layer.transform = transform;
			view.alpha = 1.f;
		}
		else if (i == 5) {
			transform = CATransform3DIdentity;
			transform = CATransform3DTranslate(transform, 0, 0, -100);
			transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
			view.layer.transform = transform;
			view.alpha = 1.f;
		}
		
		//[self applyLightingToLayer:view.layer];
	}
}

- (void)applyLightingToLayer:(CALayer *)face
{
	// Add lighting layer
	CALayer *layer = [CALayer layer];
	layer.frame = face.bounds;
	[face addSublayer:layer];
	
	// Convert the face transform to matrix
	// (GLKMatrix4 has the same structure as CATransform3D)
	// 译者注：GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换
	CATransform3D transform = face.transform;
	GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
	GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
	
	// Get face normal
	GLKVector3 normal = GLKVector3Make(0, 0, 1);
	normal = GLKMatrix3MultiplyVector3(matrix3, normal);
	normal = GLKVector3Normalize(normal);
	
	// Get dot product with light direction
	GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
	float dotProduct = GLKVector3DotProduct(light, normal);
	
	// Set lighting layer opacity
	CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
	UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
	layer.backgroundColor = color.CGColor;
}

#pragma mark - Actions

- (void)btnAction:(id)sender
{
	NSLog(@"btnAction");
}

@end
