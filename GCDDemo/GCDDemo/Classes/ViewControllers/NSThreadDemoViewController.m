//
//  NSThreadDemoViewController.m
//  GCDDemo
//
//  Created by leihui on 2017/5/23.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "NSThreadDemoViewController.h"

#define kButtonBaseTag		1709261500

@interface NSThreadDemoViewController ()

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation NSThreadDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
		[self setEdgesForExtendedLayout:UIRectEdgeNone];
	}
	
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction:)];
	self.navigationItem.rightBarButtonItem = rightItem;
	
	self.imageUrl = @"http://img1.3lian.com/2015/a1/84/d/95.jpg";
	self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
	_imageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	[self.view addSubview:_imageView];
	
	CGFloat width = 100.f*iPhoneWidthScaleFactor;
	CGFloat height = 44.f;
	CGFloat leftMargin = 5.f*iPhoneWidthScaleFactor;
	CGFloat topMargin = kAppView_Height-height;
	CGFloat interval = 5.f*iPhoneWidthScaleFactor;
	
	NSArray *array = @[@"Dynamic", @"Static", @"Implicit"];
	for (NSInteger i = 0; i < 3; i++) {
		CGRect frame = CGRectMake(leftMargin+(width+interval)*i, topMargin, width, height);
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = kButtonBaseTag + i;
		button.frame = frame;
		
		NSString *title = nil;
		if (i < [array count]) {
			title = array[i];
		}
		[button setTitle:title forState:UIControlStateNormal];
		[button setTitleColor:[UIColor colorWithWhite:0.f alpha:0.5] forState:UIControlStateNormal];
		[self.view addSubview:button];
		[button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	
#if 1
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	for (NSInteger i = 0; i < 100; i++) {
		dispatch_async(queue, ^{
			NSLog(@"thread: %@", [NSThread currentThread]);
		});
	}
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

/**
 *	NSThread
 *	三种开启线程方式
 *	1.动态实例化
 *	2.静态实例化
 *	3.隐式实例化
 */

// 1.动态实例化
- (void)dynamicCreateThread
{
	NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImageSource:) object:_imageUrl];
	// 设置线程的优先级(0.0~1.0, 1.0最高级)
	thread.threadPriority = 1;
	[thread start];
}

// 2.静态实例化
- (void)staticCreateThread
{
	[NSThread detachNewThreadSelector:@selector(loadImageSource:) toTarget:self withObject:_imageUrl];
}

// 3.隐式实例化
- (void)implicitCreateThread
{
	[self performSelectorInBackground:@selector(loadImageSource:) withObject:_imageUrl];
}

- (void)loadImageSource:(NSString *)imageUrl
{
	NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
	UIImage *image = [UIImage imageWithData:imageData];
	if (image) {
		[self performSelectorOnMainThread:@selector(refreshImageView:) withObject:image waitUntilDone:YES];
	}
	else {
		NSLog(@"Error: there no image data");
	}
}

- (void)refreshImageView:(UIImage *)image
{
	self.imageView.image = image;
}

#pragma mark - Actions

- (void)rightAction:(id)sender
{
	
}

- (void)btnAction:(id)sender
{
	NSInteger index = ((UIButton *)sender).tag - kButtonBaseTag;
	switch (index) {
		case 0:
			[self dynamicCreateThread];
			break;
		case 1:
			[self staticCreateThread];
			break;
		case 2:
			[self implicitCreateThread];
			break;
		default:
			break;
	}
}

@end
