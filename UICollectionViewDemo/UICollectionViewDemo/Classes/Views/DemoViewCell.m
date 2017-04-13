//
//  DemoViewCell.m
//  UICollectionViewDemo
//
//  Created by leihui on 17/3/22.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "DemoViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DemoViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DemoViewCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Init
		self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageView.backgroundColor = RGBA(0, 0, 0, 0.3);
		_imageView.contentMode = UIViewContentModeScaleAspectFill;
		_imageView.layer.borderColor = [UIColor whiteColor].CGColor;
		_imageView.layer.borderWidth = 2.f;
		_imageView.clipsToBounds = YES;
		[self addSubview:_imageView];
	}
	
	return self;
}

#pragma mark - Public

- (void)updateWithItem:(DemoItem *)item
{
	if (item) {
		NSURL *url = [NSURL URLWithString:item.iconSmallUrl];
		if (url == nil) {
			NSString *encodingUrl = [item.iconSmallUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			url = [NSURL URLWithString:encodingUrl];
			if (url) {
				[_imageView sd_setImageWithURL:url];
			}
		}
		else {
			[_imageView sd_setImageWithURL:url];
		}
	}
}

@end
