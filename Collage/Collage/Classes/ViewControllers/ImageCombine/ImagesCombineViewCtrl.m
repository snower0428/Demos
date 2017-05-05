//
//  ImagesCombineViewCtrl.m
//  ImagesCombine
//
//  Created by ZZF on 13-8-29.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import "ImagesCombineViewCtrl.h"
#import "PictureView.h"
//#import "PHPhotoHandle.h"
//#import "ResourceUpdateManager.h"

@interface ImagesCombineViewCtrl ()// <ResourceUpdateManagerDelegate>
{
    BOOL _requireResource;
}

- (void)changViewWithButtonTag:(NSInteger)tag;
- (void)changViewAction:(id)sender;

- (void)setPushTreeWithLevel:(int)level;

- (void)showTypeSettingView:(BOOL)hide;
- (void)removeTypeSettingView;
- (void)showBackgroundSettingView:(BOOL)hide;
- (void)removeBackgroundSettingView;
@end

@implementation ImagesCombineViewCtrl

@synthesize listImages = _listImages;
@synthesize delegate = _delegate;

const int kModeBtnTag = 1000;
const int kFreeBtnTag = 1001;

const int kTypeSettingViewTag       = 1002;
const int kBackgroundSettingViewTag = 1003;

#define kBackBtnTag   1004

#define kCombineWidth   250
#define kCombineHeight  340

- (void)dealloc {
	[freeCombine release];
	freeCombine = nil;

	[modeCombine release];
	modeCombine = nil;
	self.listImages = nil;
//    [_resourceMgr release];
//    _resourceMgr = nil;

	[super dealloc];
}

#pragma mark - View lifecycle

- (id)initWithImages:(NSArray *)images {
	if ((self = [super init])) {
		self.listImages = images;
	}
	return self;
}

- (void)loadView {
	[super loadView];

	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
	combineWidth = SCREEN_WIDTH;
	combineHeight = SCREEN_HEIGHT;
	backLevel = 0;

	statusHeight = STATUSBAR_HEIGHT;
	if (SYSTEM_VERSION >= 7.0) {
		statusHeight = 0;
	}

	currentIndex = MODE_SHOWTYPE;
	_backgroundType = BackgroundTypeNone;

	freeCombine = [[FreeCombineView alloc] initWithFrame:CGRectMake(0, -statusHeight, combineWidth, combineHeight) images:_listImages];

	modeCombine = [[ModeCombineView alloc] initWithFrame:CGRectMake(0, -statusHeight, combineWidth, combineHeight) images:_listImages];
	modeCombine.backgroundColor = [UIColor whiteColor];
	[modeCombine changeImagesBackgroud:10];
	[self.view addSubview:modeCombine];

	CGFloat interval = 20.f;
	CGFloat btnWidth = 80.f;
	CGFloat btnHeight = 60.f;
	CGFloat btnTitleHeight = 30.f;
    CGFloat leftMargin = (self.view.frame.size.width - btnWidth*2 - interval)/2;
    
	UIImage *image = [[ResourcesManager sharedInstance] imageWithFileName:@"/Common/Bar/BottomBarBG.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - btnHeight - statusHeight, SCREEN_WIDTH, btnHeight)];
	imageView.image = image;
	[self.view addSubview:imageView];
	[imageView release];

	// 模板拼图按钮
	modeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	modeButton.tag = kModeBtnTag;
	modeButton.backgroundColor = [UIColor clearColor];
	modeButton.frame = CGRectMake(leftMargin, SCREEN_HEIGHT - btnHeight - statusHeight, btnWidth, btnHeight);
	[modeButton setImage:getResource(@"ImageCombine/tempCollage.png") forState:UIControlStateNormal];
	[modeButton setImage:getResource(@"ImageCombine/tempCollage_p.png") forState:UIControlStateSelected];
	[modeButton addTarget:self action:@selector(changViewAction:) forControlEvents:UIControlEventTouchUpInside];
	[modeButton setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, 0)];
	[self.view addSubview:modeButton];

	UILabel *labelMode = [UILabel labelWithName:_(@"Template Collage")
	                                       font:[UIFont systemFontOfSize:14]
	                                      frame:CGRectMake(0, modeButton.bounds.size.height - btnTitleHeight, modeButton.bounds.size.width, btnTitleHeight)
	                                      color:[UIColor whiteColor]
	                                  alignment:UITextAlignmentCenter];
	[modeButton addSubview:labelMode];

	// 自由拼图按钮
	freeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	freeButton.tag = kFreeBtnTag;
	freeButton.backgroundColor = [UIColor clearColor];
	freeButton.frame = CGRectMake(leftMargin + btnWidth + interval, SCREEN_HEIGHT - btnHeight - statusHeight, btnWidth, btnHeight);
	[freeButton setImage:getResource(@"ImageCombine/freeCollage.png") forState:UIControlStateNormal];
	[freeButton setImage:getResource(@"ImageCombine/freeCollage_p.png") forState:UIControlStateSelected];
	[freeButton addTarget:self action:@selector(changViewAction:) forControlEvents:UIControlEventTouchUpInside];
	[freeButton setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, 0)];
	[self.view addSubview:freeButton];

	UILabel *labelFree = [UILabel labelWithName:_(@"Free Collage")
	                                       font:[UIFont systemFontOfSize:14]
	                                      frame:CGRectMake(0, freeButton.bounds.size.height - btnTitleHeight, freeButton.bounds.size.width, btnTitleHeight)
	                                      color:[UIColor whiteColor]
	                                  alignment:UITextAlignmentCenter];
	[freeButton addSubview:labelFree];

	btnWidth = 50.f;

	// 返回按钮
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.backgroundColor = [UIColor clearColor];
	backButton.tag = kBackBtnTag;
	backButton.frame = CGRectMake(0, SCREEN_HEIGHT - btnHeight - statusHeight, btnWidth, btnHeight);
	[backButton setImage:getResource(@"ImageCombine/collageBack.png") forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
	backButton.hidden = YES;
	[self.view addSubview:backButton];

	//相框&背景
	backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backgroundButton.frame = CGRectMake(btnWidth, SCREEN_HEIGHT - 50 - statusHeight, 45, 45);
	backgroundButton.titleLabel.font = [UIFont systemFontOfSize:12];
	backgroundButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	[backgroundButton setTitle:_(@"Frame") forState:UIControlStateNormal];
	[backgroundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[backgroundButton setBackgroundImage:getResource(@"ImageCombine/btn_photo_frame.png") forState:UIControlStateNormal];
	[backgroundButton addTarget:self action:@selector(changbackgroundAction:) forControlEvents:UIControlEventTouchUpInside];
	backgroundButton.hidden = YES;
	[self.view addSubview:backgroundButton];

	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(0, 0, 70, 32);
	[doneButton setBackgroundImage:[getResource(@"Common/Button/greenBtn.png") stretchableImageWithLeftCapWidth:4 topCapHeight:16] forState:UIControlStateNormal];
	[doneButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
	[doneButton setTitle:_(@"Done") forState:UIControlStateNormal];

	UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
	self.navigationItem.rightBarButtonItem = rightitem;
	[rightitem release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
#else
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#endif
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - private

- (void)changViewWithButtonTag:(NSInteger)tag {
    
	switch (tag) {
		case kModeBtnTag:
			//[NdAnalytics event:kSelectModeCollage_ID label:kSelectModeCollage_Label];
            
			if (currentIndex == MODE_SHOWTYPE) {
				[self setPushTreeWithLevel:1];
				return;
			}
			[freeCombine removeFromSuperview];
			[self.view insertSubview:modeCombine atIndex:0];
			currentIndex = MODE_SHOWTYPE;
			[backgroundButton setTitle:_(@"Frame") forState:UIControlStateNormal];
			[self setPushTreeWithLevel:1];
            
			break;
            
		case kFreeBtnTag:
			//[NdAnalytics event:kSelectFreeCollage_ID label:kSelectFreeCollage_Label];
            
			if (currentIndex == FREE_SHOWTYPE) {
				[self setPushTreeWithLevel:1];
				return;
			}
			[modeCombine removeFromSuperview];
            
            if (_requireResource) {
                _requireResource = NO;
                [freeCombine changeImagesBackgroud:0];
            }
            
			[self.view insertSubview:freeCombine atIndex:0];
			currentIndex = FREE_SHOWTYPE;
			[backgroundButton setTitle:_(@"Background") forState:UIControlStateNormal];
			[self setPushTreeWithLevel:1];
            
			break;
            
		default:
			break;
	}
}

- (void)changViewAction:(id)sender {
	//切换模式
	NSInteger tag = [sender tag];
    
    //检测资源是否正常
//    if (_resourceMgr == nil) {
//        _resourceMgr = [[ResourceUpdateManager alloc] init];
//        _resourceMgr.delegate = self;
//    }
//    BOOL canChange = [_resourceMgr checkImageCombineResourcBundle];
//    if (!canChange) {
//        _requireResource = YES;
//        return;
//    }
	
    [self changViewWithButtonTag:tag];
}

- (void)changbackgroundAction:(id)sender {
	//选择相框&背景
	NSLog(@"换背景");
	[self setPushTreeWithLevel:2];
}

- (void)moreActionWithIndex:(NSInteger *)index {
	[freeCombine changeIndex:*index];

//	[PHAlertMessage actionSheetTitle:nil inView:self.view delegate:self tag:kDefaltActionSheetTag
//	                     cancelButtonTitle:_(@"Cancel") destructiveButtonTitle:nil
//	    otherButtonTitlesotherButtonTitles:_(@"Photo album"), _(@"Take a photo"), nil];
}

- (void)saveButtonAction:(id)sender {
	//设置为0后系统会默认的识别scale
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(combineWidth, combineHeight), NO, 0);
	if (currentIndex == MODE_SHOWTYPE) {
		[modeCombine.layer renderInContext:UIGraphicsGetCurrentContext()];
	}
	else
		[freeCombine.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

//    UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);

	//保存到相册
//	PHPhotoHandle *photoHandle = [[PHPhotoHandle alloc] init];
//	[photoHandle saveImageToPhotos:image];
//	[photoHandle release];

	//跳转到DIY界面
	if (_delegate && [_delegate respondsToSelector:@selector(ImagesCombineViewCtrlDone:image:)]) {
		[_delegate ImagesCombineViewCtrlDone:self image:image];
	}
}

#pragma 层级管理器

- (void)backAction:(id)sender {
	backLevel--;
	[self setPushTreeWithLevel:backLevel];
}

- (void)setPushTreeWithLevel:(int)level {
	UIButton *backButton = (UIButton *)[self.view viewWithTag:kBackBtnTag];

	switch (level) {
		case 0: {
			modeButton.hidden = NO;
			freeButton.hidden = NO;
			backButton.hidden = YES;
			backgroundButton.hidden = YES;
			[self removeTypeSettingView];
			[self removeBackgroundSettingView];
		}
		break;

		case 1: {
			modeButton.hidden = YES;
			freeButton.hidden = YES;

			backButton.hidden = NO;
			backgroundButton.hidden = NO;
			[self showTypeSettingView:NO];
			[self removeBackgroundSettingView];
		}
		break;

		case 2: {
			modeButton.hidden = YES;
			freeButton.hidden = YES;

			backButton.hidden = NO;
			backgroundButton.hidden = YES;
			[self showTypeSettingView:YES];
			[self showBackgroundSettingView:NO];
		}
		break;

		default:
			break;
	}
	backLevel = level;
}

- (void)showTypeSettingView:(BOOL)hide {
	CombineTypeSettingView *settingView = (CombineTypeSettingView *)[self.view viewWithTag:kTypeSettingViewTag];
	if (settingView == nil) {
		settingView = [[CombineTypeSettingView alloc] initWithFrame:CGRectMake(100, CGRectGetHeight(self.view.frame) - 55, CGRectGetWidth(self.view.frame) - 100, 55)];
		settingView.tag = kTypeSettingViewTag;
		settingView.delegate = self;
		NSInteger itemCount = 0;
		NSInteger typeIndex = 0;
		NSInteger imageCount = 0;
		if (currentIndex == MODE_SHOWTYPE) {
			typeIndex = modeCombine.typeIndex;
			imageCount = modeCombine.imageCount;
			NSArray *views = [modeCombine.plistDic objectForKey:@"views"];
			if (views && [views isKindOfClass:[NSArray class]]) {
				itemCount = [views count];
			}
		}
		else {
			typeIndex = freeCombine.typeIndex;
			imageCount = freeCombine.imageCount;
			NSArray *views = [freeCombine.plistDic objectForKey:@"views"];
			if (views && [views isKindOfClass:[NSArray class]]) {
				itemCount = [views count];
			}
		}
		_backgroundType = BackgroundTypeNone;
		[settingView initWithSubViews:itemCount selectIndex:typeIndex type:currentIndex backgroundType:_backgroundType imageCount:imageCount];
		[self.view addSubview:settingView];
		[settingView release];
	}
	settingView.hidden = hide;
}

- (void)removeTypeSettingView {
	CombineTypeSettingView *settingView = (CombineTypeSettingView *)[self.view viewWithTag:kTypeSettingViewTag];
	if (settingView) {
		[settingView removeFromSuperview];
	}
}

- (void)showBackgroundSettingView:(BOOL)hide {
	CombineTypeSettingView *settingView = (CombineTypeSettingView *)[self.view viewWithTag:kBackgroundSettingViewTag];
	if (settingView == nil) {
		settingView = [[CombineTypeSettingView alloc] initWithFrame:CGRectMake(50, CGRectGetHeight(self.view.frame) - 55, CGRectGetWidth(self.view.frame) - 50, 55)];
		settingView.tag = kBackgroundSettingViewTag;
		settingView.delegate = self;
		NSInteger itemCount = 0;
		NSInteger backIndex = 0;
		NSInteger imageCount = 0;
		if (currentIndex == MODE_SHOWTYPE) {
			itemCount = 5;
			backIndex = modeCombine.backIndex;
			imageCount = modeCombine.imageCount;
			_backgroundType = BackgroundTypePhotoFrame;
		}
		else {
			itemCount = 5;
			backIndex = freeCombine.backIndex;
			imageCount = freeCombine.imageCount;
			_backgroundType = BackgroundTypeBackground;
		}

		[settingView initWithSubViews:itemCount selectIndex:backIndex type:currentIndex backgroundType:_backgroundType imageCount:imageCount];
		[self.view addSubview:settingView];
		[settingView release];
	}
	settingView.hidden = hide;
}

- (void)removeBackgroundSettingView {
	CombineTypeSettingView *settingView = (CombineTypeSettingView *)[self.view viewWithTag:kBackgroundSettingViewTag];
	if (settingView) {
		[settingView removeFromSuperview];
	}
}

#pragma CombineTypeSettingViewDelegate

- (void)imageTouchedAction:(CombineTypeSettingView *)view typeIndex:(NSInteger)index {
	NSInteger tag = view.tag;
	switch (tag) {
		case kTypeSettingViewTag: {
			if (currentIndex == MODE_SHOWTYPE) {
				[modeCombine changeImagesFrame:index];
			}
			else {
				[freeCombine changeImagesFrame:index];
			}
		}
		break;

		case kBackgroundSettingViewTag: {
			if (currentIndex == MODE_SHOWTYPE) {
				[modeCombine changeImagesBackgroud:index];
			}
			else {
				[freeCombine changeImagesBackgroud:index];
			}
		}
		break;

		default:
			break;
	}
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		[self presentModalViewController:imagePicker animated:YES];
		[imagePicker release];
	}
	else if (buttonIndex == 1) {
#if TARGET_IPHONE_SIMULATOR
		NSLog(@"模拟器不能使用相机");
#else
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
			imagePicker.delegate = self;
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
			imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
			[self presentModalViewController:imagePicker animated:YES];
			[imagePicker release];
		}
		else {
			//[PHAlertMessage alertMessage:_(@"Your device is not available camera") title:nil cancelButtonTitle:_(@"OK") otherButtonTitles:nil];
		}
#endif
	}
}

#pragma mark - PHImagePickerViewCtrlDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	[freeCombine changeBackgroundWith:image];

	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - ResourceUpdateManagerDelegate <NSObject>
- (UIView *)showMessageView
{
    return self.view;
}

@end
