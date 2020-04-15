//
//  GPUImageViewController01.m
//  GPUImageDemo
//
//  Created by leihui on 17/4/11.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewController01.h"

@interface GPUImageViewController01 ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) GPUImageBrightnessFilter *brightnessFilter;
@property (nonatomic, strong) GPUImageContrastFilter *contrastFilter;
@property (nonatomic, strong) GPUImageSaturationFilter *saturationFilter;
@property (nonatomic, strong) GPUImageExposureFilter *exposureFilter;
@property (nonatomic, strong) GPUImageWhiteBalanceFilter *whiteBalanceFilter;
@property (nonatomic, strong) GPUImagePicture *gpuImagePicture;

@end

@implementation GPUImageViewController01

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self createNavigationItem];
	
	self.bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	_bgView.image = getResource(@"test01.jpg");
	[self.view addSubview:_bgView];
	
	[self createSliderView];
	//[self createBrightnessFilter];
	//[self createContrastFilter];
	//[self createSaturationFilter];
	//[self createExposureFilter];
	[self createWhiteBalanceFilter];
	[self createImagePicture];
    
    
//    /// 总大小
//      float totalsize = 0.0;
//      /// 剩余大小
//      float freesize = 0.0;
//      /// 是否登录
//      NSError *error = nil;
//      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//      NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
//      if (dictionary)
//      {
//          NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
//          freesize = [_free unsignedLongLongValue]*1.0/(1024);
//          
//          NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
//          totalsize = [_total unsignedLongLongValue]*1.0/(1024);
//      } else
//      {
//          NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
//      }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)createNavigationItem
{
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction:)];
	self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)createSliderView
{
	CGFloat leftMargin = 10.f;
	CGRect frame = CGRectMake(leftMargin, SCREEN_HEIGHT - 50.f, SCREEN_WIDTH-leftMargin*2, 50.f);
	
	UISlider *slider = [[UISlider alloc] initWithFrame:frame];
	slider.minimumValue = 1000.0;
	slider.maximumValue = 10000.0;
	slider.value = 5000.0;
	[self.view addSubview:slider];
	[slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	
	frame = CGRectMake(leftMargin, SCREEN_HEIGHT - 100.f, SCREEN_WIDTH-leftMargin*2, 50.f);
	
	UISlider *slider2 = [[UISlider alloc] initWithFrame:frame];
	slider2.minimumValue = -1000.0;
	slider2.maximumValue = 1000.0;
	slider2.value = 0.0;
	[self.view addSubview:slider2];
	[slider2 addTarget:self action:@selector(sliderAction2:) forControlEvents:UIControlEventValueChanged];
}

- (void)createBrightnessFilter
{
	self.brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
	_brightnessFilter.brightness = 0.0;
}

- (void)createContrastFilter
{
	self.contrastFilter = [[GPUImageContrastFilter alloc] init];
	_contrastFilter.contrast = 1.0;
}

- (void)createSaturationFilter
{
	self.saturationFilter = [[GPUImageSaturationFilter alloc] init];
	_saturationFilter.saturation = 1.0;
}

- (void)createExposureFilter
{
	self.exposureFilter = [[GPUImageExposureFilter alloc] init];
	_exposureFilter.exposure = 0.0;
}

- (void)createWhiteBalanceFilter
{
	self.whiteBalanceFilter = [[GPUImageWhiteBalanceFilter alloc] init];
	
}

- (void)createImagePicture
{
	UIImage *image = getResource(@"test01.jpg");
	self.gpuImagePicture = [[GPUImagePicture alloc] initWithImage:image];
}

#pragma mark - Actions

- (void)rightAction:(id)sender
{
	if (_imageView) {
		[_imageView removeFromSuperview];
		self.imageView = nil;
		return;
	}
	self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_imageView];
	
	UIImage *image = getResource(@"test01.jpg");
	if (image) {
		GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
		image = [filter imageByFilteringImage:image];
		_imageView.image = image;
	}
}

- (void)sliderAction:(id)sender
{
	CGFloat value = ((UISlider *)sender).value;
	
#if 0
	_brightnessFilter.brightness = value;
	
	[_gpuImagePicture addTarget:_brightnessFilter];
	[_gpuImagePicture processImage];
	
	[_brightnessFilter useNextFrameForImageCapture];
	
	UIImage *image = [_brightnessFilter imageFromCurrentFramebuffer];
	_bgView.image = image;
#endif
	
#if 0
	_contrastFilter.contrast = value;
	
	[_gpuImagePicture addTarget:_contrastFilter];
	[_gpuImagePicture processImage];
	
	[_contrastFilter useNextFrameForImageCapture];
	
	UIImage *image = [_contrastFilter imageFromCurrentFramebuffer];
	_bgView.image = image;
#endif
	
#if 0
	_saturationFilter.saturation = value;
	
	[_gpuImagePicture addTarget:_saturationFilter];
	[_gpuImagePicture processImage];
	
	[_saturationFilter useNextFrameForImageCapture];
	
	UIImage *image = [_saturationFilter imageFromCurrentFramebuffer];
	_bgView.image = image;
#endif
	
#if 0
	_exposureFilter.exposure = value;
	
	[_gpuImagePicture addTarget:_exposureFilter];
	[_gpuImagePicture processImage];
	
	[_exposureFilter useNextFrameForImageCapture];
	
	UIImage *image = [_exposureFilter imageFromCurrentFramebuffer];
	_bgView.image = image;
#endif
	
	_whiteBalanceFilter.temperature = value;
	
	[_gpuImagePicture addTarget:_whiteBalanceFilter];
	[_gpuImagePicture processImage];
	
	[_whiteBalanceFilter useNextFrameForImageCapture];
	
	UIImage *image = [_whiteBalanceFilter imageFromCurrentFramebuffer];
	_bgView.image = image;
}

- (void)sliderAction2:(id)sender
{
	CGFloat value = ((UISlider *)sender).value;
	
	_whiteBalanceFilter.tint = value;
	
	[_gpuImagePicture addTarget:_whiteBalanceFilter];
	[_gpuImagePicture processImage];
	
	[_whiteBalanceFilter useNextFrameForImageCapture];
	
	UIImage *image = [_whiteBalanceFilter imageFromCurrentFramebuffer];
	_bgView.image = image;
}

@end
