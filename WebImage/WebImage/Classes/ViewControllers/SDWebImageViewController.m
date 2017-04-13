//
//  SDWebImageViewController.m
//  WebImage
//
//  Created by leihui on 17/3/28.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "SDWebImageViewController.h"
#import "ImageList.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kImageViewBaseTag		8000

@interface SDWebImageViewController ()

@end

@implementation SDWebImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
		[self setEdgesForExtendedLayout:UIRectEdgeNone];
	}
	self.view.backgroundColor = RGB(40, 40, 40);
	
	[[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
	[[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
	
#if 1
	[self createSingleView];
#else
	[self createContentView];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)createSingleView
{
	CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
	[self.view addSubview:imageView];
	
	NSArray *array = [[ImageList sharedInstance] list];
	if ([array count] > 0) {
		NSString *strUrl = array[0];
		NSURL *url = [NSURL URLWithString:strUrl];
		[imageView sd_setImageWithURL:url];
	}
}

- (void)createContentView
{
	NSArray *array = [[ImageList sharedInstance] list];
	NSInteger count = [array count];
	
	CGFloat leftMargin = 1.f*iPhoneWidthScaleFactor;
	CGFloat topMargin = 1.f*iPhoneWidthScaleFactor;
	CGFloat width = 30.f*iPhoneWidthScaleFactor;
	CGFloat height = 30.f*iPhoneWidthScaleFactor;
	CGFloat xInterval = 2.f*iPhoneWidthScaleFactor;
	CGFloat yInterval = 2.f*iPhoneWidthScaleFactor;
	NSInteger numberOfColumns = 10;
	
	for (NSInteger i = 0; i < count; i++) {
		CGRect frame = CGRectMake(leftMargin+(width+xInterval)*(i%numberOfColumns), topMargin+(height+yInterval)*(i/numberOfColumns), width, height);
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
		imageView.tag = kImageViewBaseTag+i;
		imageView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:imageView];
		
		NSString *strUrl = array[i];
		NSURL *url = [NSURL URLWithString:strUrl];
		[imageView sd_setImageWithURL:url];
	}
}

@end
