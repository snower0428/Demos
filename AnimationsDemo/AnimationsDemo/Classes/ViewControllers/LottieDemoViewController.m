//
//  LottieDemoViewController.m
//  AnimationsDemo
//
//  Created by leihui on 2017/11/23.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "LottieDemoViewController.h"
#import <Lottie/Lottie.h>
#import "CEMovieMaker.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <AVFoundation/AVFoundation.h>

#define WeakObj(obj) __weak typeof(obj) obj##Weak = obj

@interface LottieDemoViewController () <TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) LOTAnimationView *animationView;

@property (nonatomic, strong) CEMovieMaker *movieMaker;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation LottieDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	CGRect frame = CGRectMake(0, 64.f, SCREEN_WIDTH, SCREEN_WIDTH);
	self.containerView = [[UIView alloc] initWithFrame:frame];
	_containerView.clipsToBounds = YES;
	[self.view addSubview:_containerView];
	
	self.imageView = [[UIImageView alloc] initWithFrame:_containerView.bounds];
	_imageView.image = [UIImage imageNamed:@"test.jpg"];
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	//[_containerView addSubview:_imageView];
	
	[self createNavigationItem];
	//[self createAnimationView];
	
	//_index = 1;
	[self moveToDocuments];
	[self prepareAudio];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
#if 0
	CGRect imageViewFrame = _imageView.frame;
	imageViewFrame.origin.x -= CGRectGetWidth(imageViewFrame)*0.3;
	imageViewFrame.size.width += CGRectGetWidth(imageViewFrame)*0.6;
	imageViewFrame.size.height += CGRectGetHeight(imageViewFrame)*0.6;
	
	[UIView animateWithDuration:_animationView.animationDuration animations:^{
		_imageView.frame = imageViewFrame;
	}];
	
	//[self playAnimation];
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[self stopAudio];
}

#pragma mark - Private

- (NSString *)documentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths firstObject];
	return documentsDirectory;
}

- (void)moveToDocuments
{
	NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"data3" ofType:@"json"];
	NSString *destPath = [[self documentsDirectory] stringByAppendingPathComponent:@"data3.json"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:jsonPath]) {
		[fileManager copyItemAtPath:jsonPath toPath:destPath error:NULL];
	}
	NSString *imagesPath = [[self documentsDirectory] stringByAppendingPathComponent:@"images"];
	if (![fileManager fileExistsAtPath:imagesPath]) {
		[fileManager createDirectoryAtPath:imagesPath withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	
	for (NSInteger i = 0; i < 3; i++) {
		NSString *imageName = [NSString stringWithFormat:@"img_%zd.png", i];
		UIImage *image = [UIImage imageNamed:imageName];
		if (image) {
			NSString *filePath = [imagesPath stringByAppendingPathComponent:imageName];
			[image writeToFile:filePath atomically:YES];
		}
	}
}

- (void)replaceDocumentWithImages:(NSArray *)images
{
	NSString *imagesPath = [[self documentsDirectory] stringByAppendingPathComponent:@"images"];
	for (NSInteger i = 0; i < [images count]; i++) {
		NSString *imageName = [NSString stringWithFormat:@"img_%zd.png", i];
		UIImage *image = images[i];
		
		if (image && [image isKindOfClass:[UIImage class]]) {
			NSString *filePath = [imagesPath stringByAppendingPathComponent:imageName];
			[image writeToFile:filePath atomically:YES];
		}
	}
}

- (void)createNavigationItem
{
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			   target:self
																			   action:@selector(rightAction:)];
	self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)createAnimationView
{
	if (_animationView) {
		[_animationView removeFromSuperview];
		self.animationView = nil;
	}
	//self.animationView = [LOTAnimationView animationNamed:@"data3.json"];
	self.animationView = [LOTAnimationView animationWithFilePath:[[self documentsDirectory] stringByAppendingPathComponent:@"data3.json"]];
	_animationView.frame = _containerView.bounds;
	_animationView.cacheEnable = NO;
	_animationView.contentMode = UIViewContentModeScaleAspectFill;
	_animationView.animationSpeed = 0.3;
	[_containerView addSubview:_animationView];
}

- (void)createAnimationViewWithIndex:(NSInteger)index
{
	if (_animationView) {
		[_animationView removeFromSuperview];
		self.animationView = nil;
	}
	NSString *name = [NSString stringWithFormat:@"data%zd.json", index];
	self.animationView = [LOTAnimationView animationNamed:name];
	_animationView.frame = _containerView.bounds;
	_animationView.cacheEnable = NO;
	_animationView.contentMode = UIViewContentModeScaleAspectFill;
	_animationView.animationSpeed = 0.3;
	[_containerView addSubview:_animationView];
}

- (void)playAnimation
{
	[_animationView playWithCompletion:^(BOOL animationFinished) {
		_index++;
		if (_index <= 3) {
			[self playWithIndex:_index];
		}
	}];
}

- (void)playWithIndex:(NSInteger)index
{
	[self createAnimationViewWithIndex:index];
	[self playAnimation];
}

- (void)selectImages
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths firstObject];
	
	NSMutableArray *arrayImage = [NSMutableArray array];
	for (NSInteger i = 0; i < 2; i++) {
		NSInteger random = arc4random()%9 + 1;
		NSString *imageName = [NSString stringWithFormat:@"%03zd.jpg", random];
		UIImage *image = [UIImage imageNamed:imageName];
		if (image) {
			[arrayImage addObject:image];
		}
	}
	
	NSString *imagesPath = [documentsDirectory stringByAppendingPathComponent:@"images"];
	for (NSInteger i = 0; i < 2; i++) {
		if (i < arrayImage.count) {
			NSString *fileName = [NSString stringWithFormat:@"img_%zd.png", i];
			NSString *filePath = [imagesPath stringByAppendingPathComponent:fileName];
			UIImage *image = arrayImage[i];
			[image writeToFile:filePath atomically:YES];
		}
	}
}

- (void)produceImages
{
	_animationView.animationProgress = 0;
	_imageView.frame = _animationView.bounds;
	
	NSMutableArray *arrayImage = [NSMutableArray array];
	NSInteger endFrame = [_animationView.sceneModel.endFrame integerValue];
	CGFloat step = 1.f/endFrame;
	CGFloat originStep = CGRectGetWidth(_animationView.frame)*0.3/endFrame;
	
	for (NSInteger i = 0; i < endFrame; i++) {
		_animationView.animationProgress = step*i;
		_imageView.frame = CGRectMake(-originStep*i, 0, CGRectGetWidth(_animationView.frame)+originStep*2*i, CGRectGetWidth(_animationView.frame)+originStep*2*i);
		UIImage *image = [UIImage imageWithView:_containerView];
		if (image) {
			[arrayImage addObject:image];
		}
	}
	
	CGSize imageSize = CGSizeZero;
	CGFloat scale = 0.f;
	if (arrayImage.count > 0) {
		UIImage *image = arrayImage[0];
		imageSize = image.size;
		scale = image.scale;
	}
	NSInteger videoWidth = imageSize.width*scale;
	if (videoWidth%16 != 0) {
		videoWidth -= videoWidth%16;
	}
	NSDictionary *settings = [CEMovieMaker videoSettingsWithCodec:AVVideoCodecH264 withWidth:videoWidth andHeight:videoWidth];
	self.movieMaker = [[CEMovieMaker alloc] initWithSettings:settings];
	[self.movieMaker createMovieFromImages:[arrayImage copy] withCompletion:^(NSURL *fileURL){
		NSLog(@"");
	}];
}

- (void)showImagePicker
{
	TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
	// imagePickerVc.navigationBar.translucent = NO;
	
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
	//imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
	
//	if (self.maxCountTF.text.integerValue > 1) {
//		// 1.设置目前已经选中的图片数组
//		imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
//	}
	//imagePickerVc.allowTakePicture = self.showTakePhotoBtnSwitch.isOn; // 在内部显示拍照按钮
	
	// imagePickerVc.photoWidth = 1000;
	
	// 2. Set the appearance
	// 2. 在这里设置imagePickerVc的外观
	// if (iOS7Later) {
	// imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
	// }
	// imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
	// imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
	// imagePickerVc.navigationBar.translucent = NO;
	
	// 3. Set allow picking video & photo & originalPhoto or not
	// 3. 设置是否可以选择视频/图片/原图
	//imagePickerVc.allowPickingVideo = self.allowPickingVideoSwitch.isOn;
	//imagePickerVc.allowPickingImage = self.allowPickingImageSwitch.isOn;
	//imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch.isOn;
	//imagePickerVc.allowPickingGif = self.allowPickingGifSwitch.isOn;
	//imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch.isOn; // 是否可以多选视频
	
	// 4. 照片排列按修改时间升序
	//imagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
	
	// imagePickerVc.minImagesCount = 3;
	// imagePickerVc.alwaysEnableDoneBtn = YES;
	
	// imagePickerVc.minPhotoWidthSelectable = 3000;
	// imagePickerVc.minPhotoHeightSelectable = 2000;
	
	/// 5. Single selection mode, valid when maxImagesCount = 1
	/// 5. 单选模式,maxImagesCount为1时才生效
	imagePickerVc.showSelectBtn = NO;
	//imagePickerVc.allowCrop = self.allowCropSwitch.isOn;
	//imagePickerVc.needCircleCrop = self.needCircleCropSwitch.isOn;
	// 设置竖屏下的裁剪尺寸
	//NSInteger left = 30;
	//NSInteger widthHeight = self.view.tz_width - 2 * left;
	//NSInteger top = (self.view.tz_height - widthHeight) / 2;
	//imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
	// 设置横屏下的裁剪尺寸
	// imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
	/*
	 [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
	 cropView.layer.borderColor = [UIColor redColor].CGColor;
	 cropView.layer.borderWidth = 2.0;
	 }];*/
	
	//imagePickerVc.allowPreview = NO;
	// 自定义导航栏上的返回按钮
	/*
	 [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
	 [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
	 [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
	 }];
	 imagePickerVc.delegate = self;
	 */
	
	imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
	
	// You can get the photos by block, the same as by delegate.
	// 你可以通过block或者代理，来得到用户选择的照片.
	[imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
		
	}];
	
	[self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)prepareAudio
{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
	NSURL *url = [NSURL fileURLWithPath:filePath];
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
	if (_audioPlayer) {
		[_audioPlayer prepareToPlay];
	}
}

- (void)playAudio
{
	if (!_audioPlayer.isPlaying) {
		[_audioPlayer play];
	}
}

- (void)stopAudio
{
	if (_audioPlayer.isPlaying) {
		[_audioPlayer stop];
	}
}

#pragma mark - Actions

- (void)rightAction:(id)sender
{
	//[self produceImages];
	
	//[self selectImages];
	//[self createAnimationView];
	//[_animationView playWithCompletion:^(BOOL animationFinished) {
	//	//
	//}];
	
	[self showImagePicker];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
	NSLog(@"");
	
	[self replaceDocumentWithImages:photos];
	[self createAnimationView];
	[self playAudio];
	[_animationView playWithCompletion:^(BOOL animationFinished) {
		[self stopAudio];
	}];
}

@end
