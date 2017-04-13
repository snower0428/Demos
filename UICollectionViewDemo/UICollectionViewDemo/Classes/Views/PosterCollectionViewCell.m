//
//  PosterCollectionViewCell.m
//  UICollectionViewDemo
//
//  Created by leihui on 2017/4/13.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "PosterCollectionViewCell.h"

@interface PosterCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PosterCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Init
		self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageView.contentMode = UIViewContentModeScaleAspectFill;
		_imageView.layer.borderColor = RGBA(0, 0, 0, 0.2).CGColor;
		_imageView.layer.borderWidth = 2.f;
		_imageView.clipsToBounds = YES;
		[self addSubview:_imageView];
	}
	
	return self;
}

#pragma mark - Public

- (void)updateWithImage:(UIImage *)image
{
	if (image) {
		_imageView.frame = self.bounds;
		_imageView.image = image;
	}
}

@end
