//
//  SpecialLayerViewController.m
//  CoreAnimationDemo
//
//  Created by leihui on 17/3/16.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "SpecialLayerViewController.h"
#import <CoreText/CoreText.h>

@interface SpecialLayerViewController ()

@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, strong) UIView *labelView;

@end

@implementation SpecialLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = RGB(240, 240, 240);
	
#if 0
	UIBezierPath *path = [[UIBezierPath alloc] init];
	[path moveToPoint:CGPointMake(175, 100)];
	[path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
	[path moveToPoint:CGPointMake(150, 125)];
	[path addLineToPoint:CGPointMake(150, 175)];
	[path addLineToPoint:CGPointMake(125, 225)];
	[path moveToPoint:CGPointMake(150, 175)];
	[path addLineToPoint:CGPointMake(175, 225)];
	[path moveToPoint:CGPointMake(100, 150)];
	[path addLineToPoint:CGPointMake(200, 150)];
	
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.strokeColor = [UIColor redColor].CGColor;
	shapeLayer.fillColor = [UIColor clearColor].CGColor;
	shapeLayer.lineWidth = 5.f;
	shapeLayer.lineJoin = kCALineJoinRound;
	shapeLayer.lineCap = kCALineCapRound;
	shapeLayer.path = path.CGPath;
	
	[self.view.layer addSublayer:shapeLayer];
#endif
	
#if 0
	self.layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	_layerView.backgroundColor = [UIColor orangeColor];
	[self.view addSubview:_layerView];
	_layerView.layer.masksToBounds = YES;
	
	_layerView.center = self.view.center;
	
	CGRect rect = _layerView.bounds;
	CGSize radii = CGSizeMake(80, 80);
	UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomLeft;
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
	
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.strokeColor = [UIColor blueColor].CGColor;
	shapeLayer.fillColor = [UIColor blueColor].CGColor;
	shapeLayer.lineWidth = 1.f;
	shapeLayer.lineJoin = kCALineJoinRound;
	shapeLayer.lineCap = kCALineCapRound;
	shapeLayer.path = path.CGPath;
	
	_layerView.layer.mask = shapeLayer;
#endif
	
	// CATextLayer
	self.labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
	_labelView.center = self.view.center;
	[self.view addSubview:_labelView];
	
	CATextLayer *textLayer = [CATextLayer layer];
	textLayer.frame = _labelView.bounds;
	textLayer.contentsScale = [UIScreen mainScreen].scale;
	[_labelView.layer addSublayer:textLayer];
	
	// Set text attributes
	textLayer.alignmentMode = kCAAlignmentJustified;
	textLayer.wrapped = YES;
	
	// Choose a font
	UIFont *font = [UIFont systemFontOfSize:14.f];
	
	NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum, diam odio congue lacus, vel fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet lobortis";
	
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
	
	NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
								 NSFontAttributeName: font};
	[string setAttributes:attributes range:NSMakeRange(0, [text length])];
	
	attributes = @{NSForegroundColorAttributeName: [UIColor redColor],
				   NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
				   NSFontAttributeName: font};
	[string setAttributes:attributes range:NSMakeRange(6, 5)];
	
	// Set layer text
	textLayer.string = string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation



@end
