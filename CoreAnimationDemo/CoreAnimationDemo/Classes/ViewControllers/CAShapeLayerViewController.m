//
//  CAShapeLayerViewController.m
//  CoreAnimationDemo
//
//  Created by leihui on 17/3/31.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "CAShapeLayerViewController.h"

@interface CAShapeLayerViewController ()

@end

@implementation CAShapeLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
		[self setEdgesForExtendedLayout:UIRectEdgeNone];
	}
	self.view.backgroundColor = [UIColor whiteColor];
	
	//[self testShapeLayer];
	//[self drawSimpleLayer];
	
	UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0, self.view.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextDrawImage(context, self.view.bounds, getResource(@"test.jpg").CGImage);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 200, 300)];
	imageView.image = image;
	[self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)testShapeLayer
{
	CGPoint startPoint = CGPointMake(50, 300);
	CGPoint endPoint = CGPointMake(300, 300);
	CGPoint controlPoint1 = CGPointMake(130, 200);
	CGPoint controlPoint2 = CGPointMake(220, 400);
	
	// Layer1
	CALayer *layer1 = [CALayer layer];
	layer1.frame = CGRectMake(startPoint.x, startPoint.y, 5, 5);
	layer1.backgroundColor = [UIColor redColor].CGColor;
	[self.view.layer addSublayer:layer1];
	
	// Layer2
	CALayer *Layer2 = [CALayer layer];
	Layer2.frame = CGRectMake(endPoint.x, endPoint.y, 5, 5);
	Layer2.backgroundColor = [UIColor redColor].CGColor;
	[self.view.layer addSublayer:Layer2];
	
	// Layer3
	CALayer *Layer3 = [CALayer layer];
	Layer3.frame = CGRectMake(controlPoint1.x, controlPoint1.y, 5, 5);
	Layer3.backgroundColor = [UIColor redColor].CGColor;
	[self.view.layer addSublayer:Layer3];
	
	// Layer4
	CALayer *Layer4 = [CALayer layer];
	Layer4.frame = CGRectMake(controlPoint2.x, controlPoint2.y, 5, 5);
	Layer4.backgroundColor = [UIColor redColor].CGColor;
	[self.view.layer addSublayer:Layer4];
	
	// Path
	UIBezierPath *path = [[UIBezierPath alloc] init];
	[path moveToPoint:startPoint];
	[path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
	
	// ShapeLayer
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.strokeColor = [UIColor blackColor].CGColor;
	shapeLayer.fillColor = [UIColor clearColor].CGColor;
	shapeLayer.lineWidth = 1.f;
	shapeLayer.lineJoin = kCALineJoinRound;
	shapeLayer.lineCap = kCALineCapRound;
	shapeLayer.path = path.CGPath;
	
	[self.view.layer addSublayer:shapeLayer];
	
#if 0
	CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	strokeEndAnimation.fromValue = @(0.0);
	strokeEndAnimation.toValue = @(1.0);
	strokeEndAnimation.duration = 2.f;
	[shapeLayer addAnimation:strokeEndAnimation forKey:@"strokeEndAnimation"];
#endif
	
#if 0
	CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
	animation1.fromValue = @(0.5);
	animation1.toValue = @(0.0);
	animation1.duration = 2.f;
	[shapeLayer addAnimation:animation1 forKey:@"animation1"];
	
	CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	animation2.fromValue = @(0.5);
	animation2.toValue = @(1.0);
	animation2.duration = 2.f;
	[shapeLayer addAnimation:animation2 forKey:@"animation2"];
#endif
	
#if 0
	CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
	lineWidthAnimation.fromValue = @(1.0);
	lineWidthAnimation.toValue = @(10.0);
	lineWidthAnimation.duration = 2.f;
	[shapeLayer addAnimation:lineWidthAnimation forKey:@"lineWidthAnimation"];
#endif
}

- (void)drawSimpleLayer
{
	CGFloat height = kAppView_Height;
	CGFloat layerHeight = kAppView_Height*0.2;
	
	UIBezierPath *path = [[UIBezierPath alloc] init];
	[path moveToPoint:CGPointMake(0, height-layerHeight)];
	[path addLineToPoint:CGPointMake(0, height-1)];
	[path addLineToPoint:CGPointMake(SCREEN_WIDTH, height-1)];
	[path addLineToPoint:CGPointMake(SCREEN_WIDTH, height-layerHeight)];
	[path addQuadCurveToPoint:CGPointMake(0, height-layerHeight) controlPoint:CGPointMake(SCREEN_WIDTH/2, height-layerHeight-50)];
	
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.strokeColor = [UIColor redColor].CGColor;
	shapeLayer.fillColor = [UIColor blackColor].CGColor;
	shapeLayer.lineWidth = 1.f;
	shapeLayer.lineJoin = kCALineJoinRound;
	shapeLayer.lineCap = kCALineCapRound;
	shapeLayer.path = path.CGPath;
	
	[self.view.layer addSublayer:shapeLayer];
}

@end
