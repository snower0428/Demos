//
//  CATransformLayerViewController.m
//  CoreAnimationDemo
//
//  Created by leihui on 17/3/16.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "CATransformLayerViewController.h"
#import "JX_GCDTimerManager.h"

@interface CATransformLayerViewController ()

@end

@implementation CATransformLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	//[self rotateLayer];
	//[self rotateTransformLayer];
	[self rotateCube];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)rotateLayer
{
	CALayer *layer = [CALayer layer];
	layer.frame = CGRectMake(0, 0, 200, 200);
	layer.position = CGPointMake(self.view.center.x, self.view.center.y);
	layer.opacity = 0.6;
	layer.backgroundColor = RGB(255, 0, 0).CGColor;
	layer.borderWidth = 3;
	layer.borderColor = RGBA(255, 255, 255, 0.5).CGColor;
	layer.cornerRadius = 10;
	
	CALayer *container = [CALayer layer];
	container.frame = self.view.bounds;
	[self.view.layer addSublayer:container];
	[container addSublayer:layer];
	
	[[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"TimerRotate"
														   timeInterval:1.0
																  queue:dispatch_get_main_queue()
																repeats:YES
														   actionOption:AbandonPreviousAction
																 action:^{
																	 static CGFloat degree = 0.f;
																	 
																	 CATransform3D fromValue = CATransform3DIdentity;
																	 fromValue.m34 = -1.0 / 500.0;
																	 fromValue = CATransform3DRotate(fromValue, degree, 0, 1, 0);
																	 
																	 CATransform3D toValue = CATransform3DIdentity;
																	 toValue.m34 = -1.0 / 500.0;
																	 toValue = CATransform3DRotate(toValue, degree+=45.f, 0, 1, 0);
																	 
																	 CABasicAnimation *transform3D = [CABasicAnimation animationWithKeyPath:@"transform"];
																	 transform3D.duration = 1.f;
																	 transform3D.fromValue = [NSValue valueWithCATransform3D:fromValue];
																	 transform3D.toValue = [NSValue valueWithCATransform3D:toValue];
																	 layer.transform = toValue;
																	 [layer addAnimation:transform3D forKey:@"Transform3D"];
																 }];
}

- (void)rotateTransformLayer
{
	CALayer *layer1 = [CALayer layer];
	layer1.frame = CGRectMake(0, 0, 200, 200);
	layer1.position = CGPointMake(self.view.center.x, self.view.center.y);
	layer1.opacity = 0.6;
	layer1.backgroundColor = RGB(255, 0, 0).CGColor;
	layer1.borderWidth = 3;
	layer1.borderColor = RGBA(255, 255, 255, 0.5).CGColor;
	layer1.cornerRadius = 10;
	
	CATransform3D tranform1 = CATransform3DIdentity;
	tranform1 = CATransform3DTranslate(tranform1, 0, 0, -10);
	layer1.transform = tranform1;
	
	CALayer *layer2 = [CALayer layer];
	layer2.frame = CGRectMake(0, 0, 200, 200);
	layer2.position = CGPointMake(self.view.center.x, self.view.center.y);
	layer2.opacity = 0.6;
	layer2.backgroundColor = RGB(0, 255, 0).CGColor;
	layer2.borderWidth = 3;
	layer2.borderColor = RGBA(255, 255, 255, 0.5).CGColor;
	layer2.cornerRadius = 10;
	
	CATransform3D tranform2 = CATransform3DIdentity;
	tranform2 = CATransform3DTranslate(tranform2, 0, 0, -30);
	layer2.transform = tranform2;
	
	CATransformLayer *container = [CATransformLayer layer];
	container.frame = self.view.bounds;
	[self.view.layer addSublayer:container];
	
	[container addSublayer:layer1];
	[container addSublayer:layer2];
	
	[[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"TimerRotate"
														   timeInterval:1.0
																  queue:dispatch_get_main_queue()
																repeats:YES
														   actionOption:AbandonPreviousAction
																 action:^{
																	 static CGFloat degree = 0.f;
																	 
																	 CATransform3D fromValue = CATransform3DIdentity;
																	 fromValue.m34 = -1.0 / 500.0;
																	 fromValue = CATransform3DRotate(fromValue, degree, 0, 1, 0);
																	 
																	 CATransform3D toValue = CATransform3DIdentity;
																	 toValue.m34 = -1.0 / 500.0;
																	 toValue = CATransform3DRotate(toValue, degree+=45.f, 0, 1, 0);
																	 
																	 CABasicAnimation *transform3D = [CABasicAnimation animationWithKeyPath:@"transform"];
																	 transform3D.duration = 1.f;
																	 transform3D.fromValue = [NSValue valueWithCATransform3D:fromValue];
																	 transform3D.toValue = [NSValue valueWithCATransform3D:toValue];
																	 container.transform = toValue;
																	 [container addAnimation:transform3D forKey:@"Transform3D"];
																 }];
}

- (void)rotateCube
{
	CATransformLayer *container = [CATransformLayer layer];
	container.frame = self.view.bounds;
	[self.view.layer addSublayer:container];
	
	CATransform3D trans = CATransform3DIdentity;
	trans = CATransform3DTranslate(trans, 0, 0, 60);
	CALayer *layer1 = [self faceWithTransform:trans];
	layer1.backgroundColor = RGB(255, 0, 0).CGColor;
	[container addSublayer:layer1];
	
	trans = CATransform3DIdentity;
	trans = CATransform3DTranslate(trans, 60, 0, 0);
	trans = CATransform3DRotate(trans, M_PI_2, 0, 1, 0);
	CALayer *layer2 = [self faceWithTransform:trans];
	layer2.backgroundColor = RGB(0, 255, 0).CGColor;
	[container addSublayer:layer2];
	
	trans = CATransform3DIdentity;
	trans = CATransform3DTranslate(trans, 0, -60, 0);
	trans = CATransform3DRotate(trans, M_PI_2, 1, 0, 0);
	CALayer *layer3 = [self faceWithTransform:trans];
	layer3.backgroundColor = RGB(0, 0, 255).CGColor;
	[container addSublayer:layer3];
	
	trans = CATransform3DIdentity;
	trans = CATransform3DTranslate(trans, 0, 60, 0);
	trans = CATransform3DRotate(trans, -M_PI_2, 1, 0, 0);
	CALayer *layer4 = [self faceWithTransform:trans];
	layer4.backgroundColor = RGB(255, 255, 0).CGColor;
	[container addSublayer:layer4];
	
	trans = CATransform3DIdentity;
	trans = CATransform3DTranslate(trans, -60, 0, 0);
	trans = CATransform3DRotate(trans, -M_PI_2, 0, 1, 0);
	CALayer *layer5 = [self faceWithTransform:trans];
	layer5.backgroundColor = RGB(255, 0, 255).CGColor;
	[container addSublayer:layer5];
	
	trans = CATransform3DIdentity;
	trans = CATransform3DTranslate(trans, 0, 0, -60);
	trans = CATransform3DRotate(trans, M_PI, 0, 1, 0);
	CALayer *layer6 = [self faceWithTransform:trans];
	layer6.backgroundColor = RGB(0, 255, 255).CGColor;
	[container addSublayer:layer6];
	
#if 0
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = -1.0/500.0;
	transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
	
	container.transform = transform;
#else
	[[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"TimerRotate"
														   timeInterval:1.0
																  queue:dispatch_get_main_queue()
																repeats:YES
														   actionOption:AbandonPreviousAction
																 action:^{
																	 static CGFloat degree = 0.f;
																	 
																	 CATransform3D fromValue = CATransform3DIdentity;
																	 fromValue.m34 = -1.0 / 500.0;
																	 fromValue = CATransform3DRotate(fromValue, degree, 0, 1, 0);
																	 
																	 CATransform3D toValue = CATransform3DIdentity;
																	 toValue.m34 = -1.0 / 500.0;
																	 toValue = CATransform3DRotate(toValue, degree+=45.f, 0, 1, 0);
																	 
																	 CABasicAnimation *transform3D = [CABasicAnimation animationWithKeyPath:@"transform"];
																	 transform3D.duration = 1.f;
																	 transform3D.fromValue = [NSValue valueWithCATransform3D:fromValue];
																	 transform3D.toValue = [NSValue valueWithCATransform3D:toValue];
																	 container.transform = toValue;
																	 [container addAnimation:transform3D forKey:@"Transform3D"];
																 }];
#endif
}

- (CALayer *)faceWithTransform:(CATransform3D)transform
{
	CALayer *layer = [CALayer layer];
	layer.opacity = 0.6;
	layer.frame = CGRectMake(0, 0, 120, 120);
	layer.position = CGPointMake(self.view.center.x, self.view.center.y);
	layer.transform = transform;
	
	return layer;
}

@end
