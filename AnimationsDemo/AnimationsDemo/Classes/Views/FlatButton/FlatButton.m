//
//  FlatButton.m
//  AnimationsDemo
//
//  Created by leihui on 17/3/2.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "FlatButton.h"

@implementation FlatButton

+ (instancetype)button
{
	return [self buttonWithType:UIButtonTypeCustom];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Init
		[self setup];
	}
	return self;
}

#pragma mark -Private

- (void)setup
{
	self.backgroundColor = self.tintColor;
	self.layer.cornerRadius = 4.f;
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	self.titleLabel.font = [UIFont systemFontOfSize:16.f];
	
	[self addTarget:self action:@selector(scaleToSmall) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
	[self addTarget:self action:@selector(scaleAnimation) forControlEvents:UIControlEventTouchUpInside];
	[self addTarget:self action:@selector(scaleToDefault) forControlEvents:UIControlEventTouchDragExit];
}

#pragma mark - Actions

- (void)scaleToSmall
{
	POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
	scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
	[self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];

}

- (void)scaleAnimation
{
	POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
	scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(5.f, 5.f)];
	scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
	scaleAnimation.springBounciness = 18.0f;
	[self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault
{
	POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
	scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
	[self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}

@end
