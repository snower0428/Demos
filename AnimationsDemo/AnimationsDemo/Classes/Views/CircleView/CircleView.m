//
//  CircleView.m
//  AnimationsDemo
//
//  Created by leihui on 17/3/2.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "CircleView.h"

@interface CircleView ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Init
		NSAssert(frame.size.width == frame.size.height, @"A circle must have the same height and width.");
		[self createCircleLayer];
	}
	return self;
}

- (void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated
{
	if (animated) {
		[self animateToStrokeEnd:strokeEnd];
		return;
	}
	self.circleLayer.strokeEnd = strokeEnd;
}

#pragma mark - Setter

- (void)setStrokeColor:(UIColor *)strokeColor
{
	_strokeColor = strokeColor;
	self.circleLayer.strokeColor = strokeColor.CGColor;
}

#pragma mark - Private

- (void)createCircleLayer
{
	CGFloat lineWidth = 4.f;
	CGFloat radius = (CGRectGetWidth(self.bounds)-lineWidth)/2;
	CGRect rect = CGRectMake(lineWidth/2, lineWidth/2, radius*2, radius*2);
	
	self.circleLayer = [CAShapeLayer layer];
	self.circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
	self.circleLayer.strokeColor = self.tintColor.CGColor;
	self.circleLayer.fillColor = nil;
	self.circleLayer.lineWidth = lineWidth;
	self.circleLayer.lineCap = kCALineCapRound;
	self.circleLayer.lineJoin = kCALineJoinRound;
	
	[self.layer addSublayer:self.circleLayer];
}

- (void)animateToStrokeEnd:(CGFloat)strokeEnd
{
	POPSpringAnimation *strokeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
	strokeAnimation.toValue = @(strokeEnd);
	strokeAnimation.springBounciness = 12.f;
	strokeAnimation.removedOnCompletion = NO;
	[self.circleLayer pop_addAnimation:strokeAnimation forKey:@"layerStrokeAnimation"];
}

@end
