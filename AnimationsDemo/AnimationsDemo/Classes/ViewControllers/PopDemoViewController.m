//
//  PopDemoViewController.m
//  AnimationsDemo
//
//  Created by leihui on 17/2/28.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

/**
 *	5 Steps For Using Facebook Pop
 *	https://github.com/maxmyers/FacebookPop
 */

#import "PopDemoViewController.h"

@interface PopDemoViewController () <POPAnimationDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PopDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self createImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self baseAnimation];
}

#pragma mark - Private

- (void)createImageView
{
	CGRect frame = CGRectMake(10.f, 100.f, 150.f, 150.f);
	
	self.imageView = [[UIImageView alloc] initWithFrame:frame];
	_imageView.backgroundColor = [UIColor orangeColor];
	[self.view addSubview:_imageView];
}

- (void)baseAnimation
{
	// 1. Pick a Kind Of Animation //  POPBasicAnimation  POPSpringAnimation POPDecayAnimation
	POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
	
	// 2. Decide weather you will animate a view property or layer property, Lets pick a View Property and pick kPOPViewFrame
	// View Properties - kPOPViewAlpha kPOPViewBackgroundColor kPOPViewBounds kPOPViewCenter kPOPViewFrame kPOPViewScaleXY kPOPViewSize
	// Layer Properties - kPOPLayerBackgroundColor kPOPLayerBounds kPOPLayerScaleXY kPOPLayerSize kPOPLayerOpacity kPOPLayerPosition
	basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerRotation];
	
	// 3. Figure Out which of 3 ways to set toValue
	//  anim.toValue = @(1.0);
	//  anim.toValue =  [NSValue valueWithCGRect:CGRectMake(0, 0, 400, 400)];
	//  anim.toValue =  [NSValue valueWithCGSize:CGSizeMake(40, 40)];
	basicAnimation.toValue = @(M_PI/4);
	
	// 4. Create Name For Animation & Set Delegate
	basicAnimation.name = @"AnyAnimationNameYouWant";
	basicAnimation.delegate = self;
	
	// 5. Add animation to View or Layer, we picked View so self.tableView and not layer which would have been self.tableView.layer
	[_imageView.layer pop_addAnimation:basicAnimation forKey:@"WhatEverNameYouWant"];
}

#pragma mark - Tutorial

// Step 1 Pick Kind of Animation
- (void)pickKindOfAnimation
{
	// POPBasicAnimation
	POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
	// kCAMediaTimingFunctionLinear  kCAMediaTimingFunctionEaseIn  kCAMediaTimingFunctionEaseOut  kCAMediaTimingFunctionEaseInEaseOut
	basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	// POPSpringAnimation
	POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
	springAnimation.velocity = @(1000);		// change of value units per second
	springAnimation.springBounciness = 14;	// value between 0-20 default at 4
	springAnimation.springSpeed = 3;		// value between 0-20 default at 4
	
	// POPDecayAnimation
	POPDecayAnimation *decayAnimation = [POPDecayAnimation animation];
	decayAnimation.velocity = @(233);		// change of value units per second
	decayAnimation.deceleration = 0.833;	// range of 0 to 1
}

// Step 2 Decide if you will animate a view property or layer property
- (void)setupProperty
{
	/**
	 *	View Properties:
	 *
		Alpha - kPOPViewAlpha
		Color - kPOPViewBackgroundColor
		Size - kPOPViewBounds
		Center - kPOPViewCenter
		Location & Size - kPOPViewFrame
		Size - kPOPViewScaleXY
		Size(Scale) - kPOPViewSize
	 
	 *	Layer Properties
	 *
		Color - kPOPLayerBackgroundColor
		Size - kPOPLayerBounds
		Size - kPOPLayerScaleXY
		Size - kPOPLayerSize
		Opacity - kPOPLayerOpacity
		Position - kPOPLayerPosition
		X Position - kPOPLayerPositionX
		Y Position - kPOPLayerPositionY
		Rotation - kPOPLayerRotation
		Color - kPOPLayerBackgroundColor
	 */
}

// Step 3 Find your property below then add and set .toValue
- (void)setupToValue
{
	// View Properties
	
	/**
	 *	Alpha - kPOPViewAlpha
	 *
	 POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
	 basicAnimation.toValue = @(0);
	 */
	
	/**
	 *	Color - kPOPViewBackgroundColor
	 *
	 POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewBackgroundColor];
	 basicAnimation.toValue = [UIColor redColor];
	 */
	
	/**
	 *	Size - kPOPViewBounds
	 *
	 POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewBounds];
	 basicAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 90, 190)];	//first 2 values dont matter
	 */
	
	/**
	 *	Center - kPOPViewCenter
	 *
	 POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
	 basicAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
	 */
	
	/**
	 *	Location & Size - kPOPViewFrame
	 *
	 POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
	 basicAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(140, 140, 140, 140)];
	 */
	
	/**
	 *	Size - kPOPViewScaleXY
	 *
	 POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
	 basicAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(3, 2)];
	 */
	
	/**
	 *	Size(Scale) - kPOPViewSize
	 *
	 POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewSize];
	 basicAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(30, 200)];
	 */
	
	// Layer Properties
	
	/**
	 *	Color - kPOPLayerBackgroundColor
	 *
	 POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerBackgroundColor];
	 basicAnimation.toValue = [UIColor redColor];
	 */
	
	/**
	 *	Size - kPOPLayerBounds
	 *
	 POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerBounds];
	 basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(0, 0, 90, 90)]; //first 2 values dont matter
	 */
	
	/**
	 *	Size - kPOPLayerScaleXY
	 *
	 POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
	 basicAnimation.toValue= [NSValue valueWithCGSize:CGSizeMake(2, 1)];//increases width and height scales
	 */
	
	/**
	 *	Size - kPOPLayerSize
	 *
	 POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerSize];
	 basicAnimation.toValue= [NSValue valueWithCGSize:CGSizeMake(200, 200)];
	 */
	
	/**
	 *	Opacity - kPOPLayerOpacity
	 *
	 POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerOpacity];
	 basicAnimation.toValue = @(0);
	 */
	
	/**
	 *	Position - kPOPLayerPosition
	 *
	 POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPosition];
	 basicAnimation.toValue= [NSValue valueWithCGRect:CGRectMake(130, 130, 0, 0)];//last 2 values dont matter
	 */
	
	/**
	 *	X Position - kPOPLayerPositionX
	 *
	 POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
	 basicAnimation.toValue= @(240);
	 */
	
	/**
	 *	Y Position - kPOPLayerPositionY
	 *
	 POPSpringAnimation *anim = [POPSpringAnimation animation];
	 anim.property=[POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
	 anim.toValue = @(320);
	 */
	
	/**
	 *	Rotation - kPOPLayerRotation
	 *
	 POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
	 basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerRotation];
	 basicAnimation.toValue= @(M_PI/4); //2 M_PI is an entire rotation
	 */
}

// Step 4 Create Name & Delegate For Animation
- (void)setupNameAndDelegate
{
	/**
	 *
	 basicAnimation.name = @"WhatEverAnimationNameYouWant";
	 basicAnimation.delegate = self;
	 */
}

// Step 5 Add animation to View
- (void)addAnimationToView
{
	//[self.tableView pop_addAnimation:basicAnimation forKey:@"WhatEverNameYouWant"];
}

#pragma mark - POPAnimationDelegate

- (void)pop_animationDidStart:(POPAnimation *)anim
{
	NSLog(@"pop_animationDidStart");
}

- (void)pop_animationDidReachToValue:(POPAnimation *)anim
{
	NSLog(@"pop_animationDidReachToValue");
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
	NSLog(@"pop_animationDidStop");
}

- (void)pop_animationDidApply:(POPAnimation *)anim
{
	NSLog(@"pop_animationDidApply");
}

@end
