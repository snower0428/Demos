//
//  DecayViewController.m
//  AnimationsDemo
//
//  Created by leihui on 17/3/2.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "DecayViewController.h"

@interface DecayViewController () <POPAnimationDelegate>

@property (nonatomic, strong) UIControl *dragView;

@end

@implementation DecayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self createDragView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)createDragView
{
	self.dragView = [[UIControl alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 100.f)];
	self.dragView.center = self.view.center;
	self.dragView.layer.cornerRadius = CGRectGetWidth(self.dragView.frame)/2;
	self.dragView.backgroundColor = [UIColor customBlueColor];
	[self.view addSubview:self.dragView];
	[self.dragView addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
	
	UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	[self.dragView addGestureRecognizer:recognizer];
}

#pragma mark - Actions

- (void)touchDown:(UIControl *)sender
{
	[sender.layer pop_removeAllAnimations];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
	CGPoint offset = [recognizer translationInView:self.view];
	recognizer.view.center = CGPointMake(recognizer.view.center.x + offset.x, recognizer.view.center.y + offset.y);
	[recognizer setTranslation:CGPointZero inView:self.view];
	
	if (recognizer.state == UIGestureRecognizerStateEnded) {
		CGPoint velocity = [recognizer velocityInView:self.view];
		
		POPDecayAnimation *positionAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
		positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
		positionAnimation.delegate = self;
		[self.dragView.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
	}
}

#pragma mark - POPAnimationDelegate

- (void)pop_animationDidApply:(POPDecayAnimation *)anim
{
	BOOL isDragViewOutsideOfSuperView = !CGRectContainsRect(self.view.frame, self.dragView.frame);
	if (isDragViewOutsideOfSuperView) {
		POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
#if 0
		CGPoint currentVelocity = [anim.velocity CGPointValue];
		CGPoint velocity = CGPointMake(currentVelocity.x, -currentVelocity.y);
		positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
#endif
		positionAnimation.toValue = [NSValue valueWithCGPoint:self.view.center];
		[self.dragView.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
	}
}

@end
