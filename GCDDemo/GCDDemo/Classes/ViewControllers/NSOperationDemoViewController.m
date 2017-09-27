//
//  NSOperationDemoViewController.m
//  GCDDemo
//
//  Created by leihui on 2017/9/26.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "NSOperationDemoViewController.h"
#import "LoadImageOperation.h"

#define kButtonBaseTag		1709261500

@interface NSOperationDemoViewController () <LoadImageOperationDelegate>

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation NSOperationDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
		[self setEdgesForExtendedLayout:UIRectEdgeNone];
	}
	
	self.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1506423783807&di=4359e024c7ddc64bec0697eed6ff9878&imgtype=0&src=http%3A%2F%2Fpic1.16pic.com%2F00%2F04%2F84%2F16pic_484482_b.jpg";
	self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
	_imageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	[self.view addSubview:_imageView];
	
	CGFloat width = 100.f*iPhoneWidthScaleFactor;
	CGFloat height = 44.f;
	CGFloat leftMargin = 5.f*iPhoneWidthScaleFactor;
	CGFloat topMargin = kAppView_Height-height;
	CGFloat interval = 5.f*iPhoneWidthScaleFactor;
	
	NSArray *array = @[@"NSInvocation", @"NSBlock", @"Subclass"];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

/**
 *	NSOperation
 *	1.使用NSInvocationOperation
 *	2.使用NSBlockOperation
 *	3.使用自定义的NSOpeation子类
 *
 *	使用步骤：
 *	1.实例化NSOpeation，并绑定执行的操作
 *	2.创建NSOperationQueue队列，将NSOpeation添加进来
 *	3.系统会自动将NSOperationQueue队列中检测取出和执行NSOpeation操作
 */

// 1.使用NSInvocationOperation
- (void)useInvocationOperation
{
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImageSource:) object:_imageUrl];
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[queue addOperation:operation];
}

// 2.使用NSBlockOperation
- (void)useBlockOperation
{
	__block NSOperationDemoViewController *weakSelf = self;
	NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
		[weakSelf loadImageSource:weakSelf.imageUrl];
	}];
	
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[queue addOperation:operation];
}

// 3.使用自定义的NSOpeation子类
- (void)useSubclassOperation
{
	LoadImageOperation *operation = [[LoadImageOperation alloc] init];
	operation.delegate = self;
	operation.imageUrl = _imageUrl;
	
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[queue addOperation:operation];
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

- (void)btnAction:(id)sender
{
	NSInteger index = ((UIButton *)sender).tag - kButtonBaseTag;
	switch (index) {
		case 0:
			[self useInvocationOperation];
			break;
		case 1:
			[self useBlockOperation];
			break;
		case 2:
			[self useSubclassOperation];
			break;
		default:
			break;
	}
}

#pragma mark - LoadImageOperationDelegate

- (void)loadImageFinish:(UIImage *)image
{
	self.imageView.image = image;
}

@end
