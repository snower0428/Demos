//
//  ReplicatorAnimation.m
//  CoreAnimationDemo
//
//  Created by leihui on 2017/5/5.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "ReplicatorAnimation.h"

@implementation ReplicatorAnimation

+ (CALayer *)replicatorCircleLayer
{
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.frame = CGRectMake(0, 0, 100, 100);
	shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)].CGPath;
	shapeLayer.fillColor = [UIColor redColor].CGColor;
	shapeLayer.opacity = 0.0;
	
	CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.animations = @[[ReplicatorAnimation alphaAnimation], [ReplicatorAnimation scaleAnimation]];
	animationGroup.duration = 4.0;
	animationGroup.autoreverses = NO;
	animationGroup.repeatCount = HUGE;
	[shapeLayer addAnimation:animationGroup forKey:@"animationGroup"];
	
	CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
	replicatorLayer.frame = CGRectMake(0, 0, 100, 100);
	replicatorLayer.instanceDelay = 0.5;
	replicatorLayer.instanceCount = 8;
	[replicatorLayer addSublayer:shapeLayer];
	
	return replicatorLayer;
}

+ (CALayer *)replicatorWaveLayer
{
	CGFloat between = 5.0;
	CGFloat radius = (100-2*between)/3;
	
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.frame = CGRectMake(0, (100-radius)/2, radius, radius);
	shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
	shapeLayer.fillColor = [UIColor redColor].CGColor;
	[shapeLayer addAnimation:[ReplicatorAnimation scaleAnimation1] forKey:@"scaleAnimation1"];
	
	CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
	replicatorLayer.frame = CGRectMake(0, 0, 100, 100);
	replicatorLayer.instanceDelay = 0.2;
	replicatorLayer.instanceCount = 3;
	replicatorLayer.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, between+radius, 0.0, 0.0);
	[replicatorLayer addSublayer:shapeLayer];
	
	return replicatorLayer;
}

+ (CALayer *)replicatorTriangleLayer
{
	CGFloat radius = 100/4;
	CGFloat transX = 100 - radius;
	CAShapeLayer *shape = [CAShapeLayer layer];
	shape.frame = CGRectMake(0, 0, radius, radius);
	shape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
	shape.strokeColor = [UIColor redColor].CGColor;
	shape.fillColor = [UIColor redColor].CGColor;
	shape.lineWidth = 1;
	[shape addAnimation:[ReplicatorAnimation rotationAnimation:transX] forKey:@"rotateAnimation"];
	
	CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
	replicatorLayer.frame = CGRectMake(0, 0, radius, radius);
	replicatorLayer.instanceDelay = 0.0;
	replicatorLayer.instanceCount = 3;
	CATransform3D trans3D = CATransform3DIdentity;
	trans3D = CATransform3DTranslate(trans3D, transX, 0, 0);
	trans3D = CATransform3DRotate(trans3D, 120.0*M_PI/180.0, 0.0, 0.0, 1.0);
	replicatorLayer.instanceTransform = trans3D;
	[replicatorLayer addSublayer:shape];
	
	return replicatorLayer;
}

+ (CALayer *)replicatorGridLayer
{
	NSInteger column = 3;
	CGFloat between = 5.0;
	CGFloat radius = (100 - between * (column - 1))/column;
	CAShapeLayer *shape = [CAShapeLayer layer];
	shape.frame = CGRectMake(0, 0, radius, radius);
	shape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
	shape.fillColor = [UIColor redColor].CGColor;
	
	CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.animations = @[[ReplicatorAnimation scaleAnimation1], [ReplicatorAnimation alphaAnimation]];
	animationGroup.duration = 1.0;
	animationGroup.autoreverses = YES;
	animationGroup.repeatCount = HUGE;
	[shape addAnimation:animationGroup forKey:@"groupAnimation"];
	
	CAReplicatorLayer *replicatorLayerX = [CAReplicatorLayer layer];
	replicatorLayerX.frame = CGRectMake(0, 0, 100, 100);
	replicatorLayerX.instanceDelay = 0.3;
	replicatorLayerX.instanceCount = column;
	replicatorLayerX.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, radius+between, 0, 0);
	[replicatorLayerX addSublayer:shape];
	
	CAReplicatorLayer *replicatorLayerY = [CAReplicatorLayer layer];
	replicatorLayerY.frame = CGRectMake(0, 0, 100, 100);
	replicatorLayerY.instanceDelay = 0.3;
	replicatorLayerY.instanceCount = column;
	replicatorLayerY.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, radius+between, 0);
	[replicatorLayerY addSublayer:replicatorLayerX];
	
	return replicatorLayerY;
}

+ (CABasicAnimation *)alphaAnimation
{
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.fromValue = @(1.0);
	animation.toValue = @(0.0);
	
	return animation;
}

+ (CABasicAnimation *)scaleAnimation
{
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
	animation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
	
	return animation;
}

+ (CABasicAnimation *)scaleAnimation1
{
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
	animation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0.0)];
	animation.autoreverses = YES;
	animation.repeatCount = HUGE;
	animation.duration = 0.6;
	
	return animation;
}

+ (CABasicAnimation *)rotationAnimation:(CGFloat)transX
{
	CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
	CATransform3D fromValue = CATransform3DRotate(CATransform3DIdentity, 0.0, 0.0, 0.0, 0.0);
	scale.fromValue = [NSValue valueWithCATransform3D:fromValue];
	
	CATransform3D toValue = CATransform3DTranslate(CATransform3DIdentity, transX, 0.0, 0.0);
	toValue = CATransform3DRotate(toValue,120.0*M_PI/180.0, 0.0, 0.0, 1.0);
	
	scale.toValue = [NSValue valueWithCATransform3D:toValue];
	scale.autoreverses = NO;
	scale.repeatCount = HUGE;
	scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	scale.duration = 0.8;
	return scale;
}

@end
