//
//  ImageViewCell.m
//  UICollectionViewDemo
//
//  Created by leihui on 16/12/21.
//  Copyright © 2016年 ND WebSoft Inc. All rights reserved.
//

#import "ImageViewCell.h"

@interface ImageViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ImageViewCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Init
		self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageView.contentMode = UIViewContentModeScaleAspectFill;
		_imageView.layer.borderColor = [UIColor whiteColor].CGColor;
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
		_imageView.image = image;
	}
}

@end
