//
//  TestViewController.m
//  CoreAnimationDemo
//
//  Created by leihui on 17/3/27.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "TestViewController.h"
#import "DataItem.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define kSingleTestFlag		0

typedef NS_ENUM(NSInteger, UIImageType) {
	UIImageTypeUnknown	= -1,
	UIImageTypePNG,
	UIImageTypeJPEG
};

@interface TestViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSString *configPath;
@property (nonatomic, strong) NSString *savedPath;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) NSString *contentPath;

@end

@implementation TestViewController

- (id)init
{
	self = [super init];
	if (self) {
		// Init
		self.configPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resource"] stringByAppendingPathComponent:@"Configuration"];
		NSString *documetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		self.savedPath = [documetPath stringByAppendingPathComponent:@"SavedImage"];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:_savedPath]) {
			[fileManager createDirectoryAtPath:_savedPath withIntermediateDirectories:YES attributes:nil error:NULL];
		}
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
		[self setEdgesForExtendedLayout:UIRectEdgeNone];
	}
	self.view.backgroundColor = RGB(40, 40, 40);//[UIColor whiteColor];
	
#if kSingleTestFlag
	self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	_imageView.contentMode = UIViewContentModeScaleAspectFit;
	//_imageView.image = getResource(@"test.jpg");
	[self.view addSubview:_imageView];
	
	UIBezierPath *path = [[UIBezierPath alloc] init];
	[path moveToPoint:CGPointMake(624/2, 394/2)];
	[path addLineToPoint:CGPointMake(720/2, 440/2)];
	[path addLineToPoint:CGPointMake(822/2, 390/2)];
	[path addLineToPoint:CGPointMake(832/2, 470/2)];
	[path addLineToPoint:CGPointMake(794/2, 578/2)];
	[path addLineToPoint:CGPointMake(686/2, 644/2)];
	[path addLineToPoint:CGPointMake(626/2, 522/2)];
	[path addLineToPoint:CGPointMake(606/2, 464/2)];
	
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.strokeColor = [UIColor redColor].CGColor;
	shapeLayer.fillColor = [UIColor clearColor].CGColor;
	shapeLayer.lineWidth = 5.f;
	shapeLayer.lineJoin = kCALineJoinRound;
	shapeLayer.lineCap = kCALineCapRound;
	shapeLayer.path = path.CGPath;
	
	//[self.view.layer addSublayer:shapeLayer];
#endif
	
	[self createNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self barrier];
}

#pragma mark - Private

- (void)createNavigationItem
{
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAction:)];
	self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)parseDataInFolder:(NSString *)path withComponents:(NSInteger)components
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:path]) {
		NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:NULL];
		for (NSString *fileName in fileList) {
			NSString *suffix = [NSString stringWithFormat:@"_%zd_%zd.plist", components, components];
			if ([fileName hasSuffix:suffix]) {
				
				@autoreleasepool {
					NSString *plistPath = [path stringByAppendingPathComponent:fileName];
					DataItem *dataItem = [self dataItemFromFile:plistPath];
					
					__weak __typeof(self) weakSelf = self;
					dispatch_async(dispatch_get_main_queue(), ^{
						NSString *text = [NSString stringWithFormat:@"%@", dataItem.name];
						weakSelf.progressHUD.detailsLabel.text = text;
					});
					
					[self saveImageWithItem:dataItem];
					
					break;
				}
				
			}
		}
	}
}

- (void)btnAction:(id)sender
{
#if kSingleTestFlag
	// 单张
	NSString *plistPath = [_configPath stringByAppendingPathComponent:@"fVa2016_9_9.plist"];
	DataItem *dataItem = [self dataItemFromFile:plistPath];
	[self saveImageWithItem:dataItem];
#else
	self.progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	self.progressHUD.label.text = @"Loading...";
	
	__weak __typeof(self) weakSelf = self;
	dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
		
		for (NSInteger i = 0; i < 1; i++) {
			NSInteger components = 9;//i+1;
			NSString *folderName = [NSString stringWithFormat:@"collage_%zd", components];
			NSString *contentPath = [_configPath stringByAppendingPathComponent:folderName];
			NSString *path = nil;
			self.contentPath = contentPath;
			
			NSFileManager *fileManager = [NSFileManager defaultManager];
			if ([fileManager fileExistsAtPath:contentPath]) {
				NSArray *fileList = [fileManager contentsOfDirectoryAtPath:contentPath error:NULL];
				for (NSString *fileName in fileList) {
					path = [contentPath stringByAppendingPathComponent:fileName];
					[weakSelf parseDataInFolder:path withComponents:components];
				}
			}
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf.progressHUD hideAnimated:YES];
		});
	});
#endif
}

- (DataItem *)dataItemFromFile:(NSString *)plistFile
{
	DataItem *dataItem = nil;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:plistFile]) {
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistFile];
		dataItem = [DataItem yy_modelWithDictionary:dict];
	}
	
	return dataItem;
}

- (CGFloat)scaleValue:(CGFloat)value
{
	CGFloat scale = [UIScreen mainScreen].scale;
	CGFloat factor = iPhoneWidthScaleFactor;
	
	return value/scale * factor;
}

- (void)saveImageWithItem:(DataItem *)dataItem
{
	CALayer *maskLayer = [CALayer layer];
	
	CGFloat leftMargin = dataItem.frame.x;
	CGFloat topMargin = dataItem.frame.y;
	CGFloat width = dataItem.frame.width;
	CGFloat height = dataItem.frame.height;
	
	UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
	containerView.backgroundColor = [UIColor clearColor];
	
	// 0.png
	UIImage *image = [UIImage imageWithView:containerView];
	if (image) {
		[self saveImage:image withName:@"0.png" toFolder:dataItem.name];
	}
	
	NSInteger factor = 3.0;
	NSInteger index = 1;
	for (PartItem *partItem in dataItem.part) {
		UIView *singleContainerView = [[UIView alloc] initWithFrame:containerView.bounds];
		UIBezierPath *path = [[UIBezierPath alloc] init];
		if ([partItem.path.shape isEqualToString:@"rectangle"]) {
			// 形状是矩形
			leftMargin = partItem.path.rect.x;
			topMargin = partItem.path.rect.y;
			width = partItem.path.rect.width;
			height = partItem.path.rect.height;
			
			CGRect rect = CGRectMake(leftMargin/factor, topMargin/factor, width/factor, height/factor);
			path = [[path class] bezierPathWithRect:rect];
		}
		else if ([partItem.path.shape isEqualToString:@"circle"]) {
			// 形状是圆形
			CGPoint center = CGPointMake(partItem.path.circle.x/factor, partItem.path.circle.y/factor);
			path = [[path class] bezierPathWithArcCenter:center radius:partItem.path.circle.radius/factor startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
		}
		else {
			for (NSInteger i = 0; i < [partItem.path.point count]; i++) {
				PointItem *pointItem = partItem.path.point[i];
				if (i == 0) {
					[path moveToPoint:CGPointMake((leftMargin + pointItem.x)/factor, (topMargin + pointItem.y)/factor)];
				}
				else {
					[path addLineToPoint:CGPointMake((leftMargin + pointItem.x)/factor, (topMargin + pointItem.y)/factor)];
				}
			}
			[path closePath];
		}
		
		CAShapeLayer *shapeLayer = [CAShapeLayer layer];
		shapeLayer.strokeColor = [UIColor redColor].CGColor;
		shapeLayer.fillColor = [UIColor whiteColor].CGColor;
		shapeLayer.lineWidth = 2.f;
		shapeLayer.lineJoin = kCALineJoinRound;
		shapeLayer.lineCap = kCALineCapRound;
		shapeLayer.path = path.CGPath;
		
		[singleContainerView.layer addSublayer:shapeLayer];
		
		// 1.png, 2.png, 3.png ...
		UIImage *image = [UIImage imageWithView:singleContainerView];
		if (image) {
			NSString *imageName = [NSString stringWithFormat:@"%zd.png", index++];
			[self saveImage:image withName:imageName toFolder:dataItem.name];
		}
		
		[maskLayer addSublayer:shapeLayer];
	}
	
	[containerView.layer addSublayer:maskLayer];
	
#if 0
	image = [UIImage imageWithView:containerView];
	if (image) {
		[self saveImage:image withName:@"preview.png" toFolder:dataItem.name];
	}
#endif
	
#if kSingleTestFlag
	//image = [UIImage imageWithView:containerView];
	//_imageView.image = image;
	[self.view addSubview:containerView];
#else
	// 保存预览图
	NSString *thumb = dataItem.thumb;
	if (![NSString isEmptyString:thumb]) {
		NSString *folderPath = [_savedPath stringByAppendingPathComponent:dataItem.name];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:folderPath]) {
			[fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:NULL];
		}
		
		NSArray *components = [dataItem.name componentsSeparatedByString:@"_"];
		if (components && [components count] > 0) {
			NSString *strName = [NSString stringWithFormat:@"%@_%zd", components[0], dataItem.count];
			NSString *srcPath = [[_contentPath stringByAppendingPathComponent:strName] stringByAppendingPathComponent:thumb];
			NSString *destPath = [folderPath stringByAppendingPathComponent:@"preview.png"];
			if ([fileManager fileExistsAtPath:srcPath]) {
				NSData *imageData = [NSData dataWithContentsOfFile:srcPath];
				if (imageData) {
					BOOL bRet = [imageData writeToFile:destPath atomically:YES];
					if (bRet) {
						NSLog(@"");
					}
				}
			}
		}
	}
#endif
	
#if 1
	// Save image
	image = [UIImage imageWithView:containerView];
	if (image) {
		NSString *name = dataItem.name;
		if ([NSString isEmptyString:name]) {
			name = [NSString stringWithFormat:@"default%03zd.png", arc4random()%1000];
		}
		else {
			name = [NSString stringWithFormat:@"%@.png", dataItem.name];
		}
		NSString *path = [_savedPath stringByAppendingPathComponent:name];
		
		static NSInteger index = 0;
		NSData *imageData = UIImagePNGRepresentation(image);
		BOOL bRet = [imageData writeToFile:path atomically:YES];
		NSLog(@"bRet:%@ ----- index:%@", @(bRet), @(index++));
	}
#endif
}

- (void)saveImage:(UIImage *)image withName:(NSString *)imageName toFolder:(NSString *)folder
{
	if (image) {
		NSString *name = folder;
		if ([NSString isEmptyString:name]) {
			name = [NSString stringWithFormat:@"default%03zd", arc4random()%1000];
		}
		NSString *path = [_savedPath stringByAppendingPathComponent:name];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:path]) {
			[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
		}
		path = [path stringByAppendingPathComponent:imageName];
		
		NSData *imageData = UIImagePNGRepresentation(image);
		BOOL bRet = [imageData writeToFile:path atomically:YES];
		NSLog(@"bRet:%@ ----- folder:%@ ----- imageName:%@", @(bRet), folder, imageName);
	}
}

- (UIImageType)imageTypeFromData:(NSData *)imageData
{
	if (imageData.length > 4) {
		const unsigned char *bytes = [imageData bytes];
		if (bytes[0] == 0xff && bytes[1] == 0xd8 && bytes[2] == 0xff) {
			return UIImageTypeJPEG;
		}
		
		if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4e && bytes[4] == 0x47) {
			return UIImageTypePNG;
		}
	}
	return UIImageTypeUnknown;
}

- (void)barrier
{
	dispatch_queue_t queue = dispatch_queue_create("com.barrier.test", DISPATCH_QUEUE_CONCURRENT);
	
	dispatch_async(queue, ^{
		NSLog(@"1");
	});
	dispatch_async(queue, ^{
		NSLog(@"2");
	});
	dispatch_async(queue, ^{
		NSLog(@"3");
	});
	dispatch_async(queue, ^{
		NSLog(@"4");
	});
	dispatch_async(queue, ^{
		NSLog(@"5");
	});
	
	dispatch_barrier_async(queue, ^{
		NSLog(@"barrier");
	});
	
	dispatch_async(queue, ^{
		NSLog(@"6");
	});
	dispatch_async(queue, ^{
		NSLog(@"7");
	});
	dispatch_async(queue, ^{
		NSLog(@"8");
	});
	dispatch_async(queue, ^{
		NSLog(@"9");
	});
	dispatch_async(queue, ^{
		NSLog(@"10");
	});
}

@end
