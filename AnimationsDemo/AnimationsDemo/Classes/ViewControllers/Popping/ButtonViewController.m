//
//  ButtonViewController.m
//  AnimationsDemo
//
//  Created by leihui on 17/3/2.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "ButtonViewController.h"
#import "FlatButton.h"

@interface ButtonViewController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self createButton];
	[self createLabel];
	[self createActivityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)createButton
{
	CGFloat btnWidth = 120.f;
	CGFloat btnHeight = 50.f;
	CGFloat leftMargin = (SCREEN_WIDTH-btnWidth)/2;
	CGFloat topMargin = 200.f;
	
	self.button = [FlatButton button];
	_button.frame = CGRectMake(leftMargin, topMargin, btnWidth, btnHeight);
	_button.backgroundColor = [UIColor customBlueColor];
	//_button.alpha = 0.5;
	[_button setTitle:@"Log in" forState:UIControlStateNormal];
	[self.view addSubview:_button];
	[_button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createLabel
{
	CGFloat width = SCREEN_WIDTH;
	CGFloat height = 50.f;
	CGFloat leftMargin = 0.f;
	CGFloat topMargin = CGRectGetMinY(_button.frame);
	
	CGRect frame = CGRectMake(leftMargin, topMargin, width, height);
	
	self.errorLabel = [UILabel new];
	self.errorLabel.frame = frame;
	self.errorLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18];
	self.errorLabel.textColor = [UIColor customRedColor];
	self.errorLabel.text = @"Just a serious login error.";
	self.errorLabel.textAlignment = NSTextAlignmentCenter;
	[self.view insertSubview:self.errorLabel belowSubview:self.button];
	
	self.errorLabel.layer.opacity = 0.0;
}

- (void)createActivityIndicatorView
{
	self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
	self.navigationItem.rightBarButtonItem = item;
}

- (void)shakeButton
{
	POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
	positionAnimation.velocity = @2000;
	positionAnimation.springBounciness = 20;
	[positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
		self.button.userInteractionEnabled = YES;
	}];
	[self.button.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)showLabel
{
	self.errorLabel.layer.opacity = 1.0;
	POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
	layerScaleAnimation.springBounciness = 18;
	layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
	[self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];
	
	POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
	layerPositionAnimation.toValue = @(self.button.layer.position.y + CGRectGetHeight(self.button.frame));
	layerPositionAnimation.springBounciness = 12;
	[self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}

- (void)hideLabel
{
	POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
	layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
	[self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
	
	POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
	layerPositionAnimation.toValue = @(self.button.layer.position.y);
	[self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}

#pragma mark - Actions

- (void)btnAction:(id)sender
{
	[self hideLabel];
	[self.activityIndicatorView startAnimating];
	self.button.userInteractionEnabled = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	__block __typeof(self) weakSelf = self;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[weakSelf.activityIndicatorView stopAnimating];
		[weakSelf shakeButton];
		[weakSelf showLabel];
	});
}

@end
