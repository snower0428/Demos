//
//  CAReplicatorLayerViewController.m
//  CoreAnimationDemo
//
//  Created by leihui on 2017/5/5.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "CAReplicatorLayerViewController.h"
#import "ReplicatorAnimation.h"

@interface LHReflectionView : UIView

@end

@implementation LHReflectionView

+ (Class)layerClass
{
	return [CAReplicatorLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Init
		[self setUp];
	}
	return self;
}

- (void)setUp
{
	CAReplicatorLayer *layer = (CAReplicatorLayer *)self.layer;
	layer.instanceCount = 2;
	
	CGFloat verticalOffset = self.bounds.size.height+2;
	
	CATransform3D transform = CATransform3DIdentity;
	transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
	transform = CATransform3DScale(transform, 1, -1, 0);
	layer.instanceTransform = transform;
	
	layer.instanceAlphaOffset = -0.6;
}

@end

@interface CAReplicatorLayerViewController ()

@property (nonatomic, strong) UIImageView *containerView;

@end

@implementation CAReplicatorLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor lightGrayColor];
	
	//[self testLayer];
	//[self testReflection];
	[self testAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)testLayer
{
	CGFloat width = 100;
	CGFloat height = 100;
	CGFloat leftMargin = (CGRectGetWidth(self.view.frame)-width)/2;
	CGFloat topMargin = (CGRectGetHeight(self.view.frame)-height)/2;
	
	self.containerView = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
	_containerView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:_containerView];
	
	CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
	replicator.backgroundColor = [UIColor blueColor].CGColor;
	replicator.frame = _containerView.bounds;
	[_containerView.layer addSublayer:replicator];
	
	replicator.instanceCount = 3;
	
	CATransform3D transform = CATransform3DIdentity;
	transform = CATransform3DTranslate(transform, 0, 200, 0);
	transform = CATransform3DRotate(transform, M_PI/5, 0, 0, 1);
	transform = CATransform3DTranslate(transform, 0, -200, 0);
	replicator.instanceTransform = transform;
	
	replicator.instanceBlueOffset = -0.1;
	replicator.instanceGreenOffset = -0.1;
	
	CALayer *layer = [CALayer layer];
	layer.frame = CGRectMake(100, 100, 100, 100);
	layer.backgroundColor = [UIColor whiteColor].CGColor;
	[replicator addSublayer:layer];
}

- (void)testReflection
{
	LHReflectionView *reflectionView = [[LHReflectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
	[self.view addSubview:reflectionView];
	reflectionView.center = self.view.center;
	
	UIImage *image = getResource(@"test.jpg");
	
	CALayer *layer = [CALayer layer];
	layer.frame = reflectionView.bounds;
	layer.contents = (__bridge id _Nullable)(image.CGImage);
	[reflectionView.layer addSublayer:layer];
}

- (void)testAnimation
{
	UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
	containerView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:containerView];
	
	CAReplicatorLayer *replicatorLayer = (CAReplicatorLayer *)[ReplicatorAnimation replicatorCircleLayer];
	replicatorLayer.frame = containerView.bounds;
	[containerView.layer addSublayer:replicatorLayer];
	
	containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+110, 100, 100)];
	containerView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:containerView];
	
	replicatorLayer = (CAReplicatorLayer *)[ReplicatorAnimation replicatorWaveLayer];
	replicatorLayer.frame = containerView.bounds;
	[containerView.layer addSublayer:replicatorLayer];
	
	containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+110+110, 100, 100)];
	containerView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:containerView];
	
	replicatorLayer = (CAReplicatorLayer *)[ReplicatorAnimation replicatorTriangleLayer];
	replicatorLayer.frame = containerView.bounds;
	[containerView.layer addSublayer:replicatorLayer];
	
	containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+110+110+110, 100, 100)];
	containerView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:containerView];
	
	replicatorLayer = (CAReplicatorLayer *)[ReplicatorAnimation replicatorGridLayer];
	replicatorLayer.frame = containerView.bounds;
	[containerView.layer addSublayer:replicatorLayer];
}

@end
