//
//  PHImagePickerViewController.m
//  ImagesCombine
//
//  Created by ZZF on 13-8-28.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import "PHImagePickerViewCtrl.h"

// Views
#import "PHImagePickerGroupCell.h"

// Controllers
#import "ImagesCombineViewCtrl.h"


#import "PHAssetCollectionView.h"
//#import "ViewControllerMgr.h"
#import "SelectedTileView.h"
//#import "PHSavePhotoResultViewCtrl.h"
//#import "PHPhotoHandle.h"
//#import "PHPhotoLibrary.h"

#define kCollectionViewTag      1000
#define kPhotoAccessErrorViewTag    1100
#define kAnimationDuration	0.3

static const CGFloat kSelectViewHeight = 150.f;

extern NSString *kUpdateAssetsCollectionViewNotification;

@interface PHImagePickerViewCtrl ()
{
    PHImageSelectView       *_selectView;
    PHAssetCollectionView   *_collectionView;
    UILabel                 *_labelNoPhoto;
    
    NSTimeInterval          _lastSelectedTime;    //上一次点击TableCell的时间
}


@property (nonatomic, retain) NSMutableArray *assetsGroups;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *selectedImageArray;

- (NSDictionary *)mediaInfoFromAsset:(ALAsset *)asset;
//获取正常尺寸的图片
-(UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;
- (void)stopThread;
- (void)loadPhotoAccessErrorView;
- (void)removePhotoAccessErrorView:(id)sender;

@end

@implementation PHImagePickerViewCtrl

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.selectedImageArray = nil;
    
    [_selectView release];
    if (_collectionView != nil) {
        [_collectionView release];
        _collectionView = nil;
    }
    
    [_labelNoPhoto release];
	//[PHPhotoLibrary exitPhotoLibrary];
    [_assetsGroups release];
    [_tableView release];
    [self stopThread];
	//[PHLabelMessage removeWaitMessageLabelInView:self.view];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        /* Check sources */
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
        /* Initialization */
        self.title = _(@"Photos");
        self.filterType = QBImagePickerFilterTypeAllPhotos;
        self.showsCancelButton = YES;
        
        self.allowsMultipleSelection = NO;
        self.limitsMinimumNumberOfSelection = NO;
        self.limitsMaximumNumberOfSelection = NO;
        self.minimumNumberOfSelection = 0;
        self.maximumNumberOfSelection = 0;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTableView];
    [self initListView];
    [self loadData];
    
    self.selectedImageArray = [NSMutableArray array];
    
//    [[PHPhotoHandle shareInstance] checkPhotoAccessWithCompletionBlock:^(NSError *error) {
//         if (error != nil) {
//             [self loadPhotoAccessErrorView];
//         }
//    }];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsLibraryChangedNotification:) name:ALAssetsLibraryChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Flash scroll indicators      
    [self.tableView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    _showsCancelButton = showsCancelButton;
    
    if(self.showsCancelButton) {
        UIBarButtonItem *item = nil;
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 60, 30);
        [rightButton setTitle:_(@"cancel") forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[getResource(@"Common/Button/orangeBtn.png") stretchableImageWithLeftCapWidth:4 topCapHeight:16] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(cancelSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(-15, 0, 1, 25)];
        line.image = getResource(@"Common/Bar/TopBarLine.png");
        [rightButton addSubview:line];
        [line release];
        item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = item;
        [item release];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}

#pragma mark - Instance Methods

- (void)initTableView
{
    // Table View
    CGRect tableFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - kSelectViewHeight);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    if (SYSTEM_VERSION >= 7.0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else  {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView release];
    
    // NO Photo
    _labelNoPhoto = [[UILabel alloc] initWithFrame:self.tableView.frame];
    _labelNoPhoto.backgroundColor = [UIColor whiteColor];
    _labelNoPhoto.font = [UIFont boldSystemFontOfSize:30];
    _labelNoPhoto.text = _(@"No Photo");
    _labelNoPhoto.textColor = [UIColor blackColor];
    _labelNoPhoto.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_labelNoPhoto];
}

- (void)initListView
{
    CGRect selectRect = CGRectMake(0, SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - kSelectViewHeight, SCREEN_WIDTH, kSelectViewHeight);
    _selectView = [[PHImageSelectView alloc] initWithFrame:selectRect];
    _selectView.delegate = self;
    [self.view addSubview:_selectView];
    
    // 开始拼图按钮
    UIImage *nortmal = [getResource(@"ImageCombine/btn_create.png") stretchableImageWithLeftCapWidth:16 topCapHeight:0];
    UIImage *hightlight = [getResource(@"ImageCombine/btn_create_d.png") stretchableImageWithLeftCapWidth:16 topCapHeight:0];
    UIButton *btnPuzzle = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPuzzle.frame = CGRectMake(_selectView.frame.size.width - 100, 6, 90, 30);
    btnPuzzle.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btnPuzzle setTitle:_(@"Puzzle") forState:UIControlStateNormal];
    [btnPuzzle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnPuzzle setBackgroundImage:nortmal forState:UIControlStateNormal];
    [btnPuzzle setBackgroundImage:hightlight forState:UIControlStateHighlighted];
    [btnPuzzle addTarget:self action:@selector(puzzleAction:) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:btnPuzzle];
}

- (void)loadData
{
    /**
     *  解决ios5.x的bug，在ios5.x下，不能接收ALAssetsLibraryChangedNotification通知
     *  可以通过一个以下方法来修正
     *  在创建了ALAssetsLibrary的实例之后，立刻执行以下方法
     */
	//[[PHPhotoLibrary sharedPhotoLibrary] writeImageToSavedPhotosAlbum:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) { }];
    
    self.assetsGroups = [NSMutableArray array];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
            if(assetsGroup) {
                switch(self.filterType) {
                    case QBImagePickerFilterTypeAllAssets:
                        [assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
                        break;
                    case QBImagePickerFilterTypeAllPhotos:
                        [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                        break;
                    case QBImagePickerFilterTypeAllVideos:
                        [assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
                        break;
                }
                
                if(assetsGroup.numberOfAssets > 0) {
                    // 隐藏没有照片Label
                    _labelNoPhoto.hidden = YES;
                    [self.assetsGroups addObject:assetsGroup];
                    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                    NSLog(@"------------------------------ assetsGroup.numberOfAssets ------------------------------ %ld", (long)assetsGroup.numberOfAssets);
                }
            }
        };
        
        void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        };
        
//        [[PHPhotoLibrary sharedPhotoLibrary] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
//        [[PHPhotoLibrary sharedPhotoLibrary] enumerateGroupsWithTypes:ALAssetsGroupLibrary usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
//        [[PHPhotoLibrary sharedPhotoLibrary] enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
//        [[PHPhotoLibrary sharedPhotoLibrary] enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
//        [[PHPhotoLibrary sharedPhotoLibrary] enumerateGroupsWithTypes:ALAssetsGroupEvent usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
//        [[PHPhotoLibrary sharedPhotoLibrary] enumerateGroupsWithTypes:ALAssetsGroupFaces usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    });
}

- (void)puzzleAction:(id)sender
{
    if (_selectView.listItems.count < 2) {
//        [PHAlertMessage alertMessage:_(@"Dear, you should select photo more than 2")
//                             title:_(@"Warm tip")
//                 cancelButtonTitle:_(@"OK")
//                 otherButtonTitles: nil];
        return;
    }
    
	//[PHLabelMessage showWaitMessageLabel:_(@"Loading") inView:[[UIApplication sharedApplication] keyWindow]];
    
#if 0
    
    if (checkThread == nil) {
        stop = NO;
        checkThread = [[NSThread alloc] initWithTarget:self selector:@selector(addImagesThread:) object:self.selectedAssets];
        [checkThread start];
    }
    
#else
    
    [self removeCollectionView];
    
    //进入拼图界面
    ImagesCombineViewCtrl * imageCombineCtrl = [[ImagesCombineViewCtrl alloc] initWithImages:self.selectedImageArray];
    imageCombineCtrl.delegate = self;
    [self.navigationController pushViewController:imageCombineCtrl animated:YES];
    [imageCombineCtrl release];
    
	//[PHLabelMessage removeWaitMessageLabelInView:[[UIApplication sharedApplication] keyWindow]];
    
#endif
}

- (void)cancelSelectAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    }
    
	//[ViewControllerMgr viewController:self dismissModalViewControllerAnimated:YES];
    
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)])
    {
    	[self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSDictionary *)mediaInfoFromAsset:(ALAsset *)asset
{
    NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
    [mediaInfo setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
    [mediaInfo setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] forKey:@"UIImagePickerControllerOriginalImage"];
    [mediaInfo setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
    
    return mediaInfo;
}

- (void)removeCollectionView
{
    if (_collectionView != nil) {
        [_collectionView removeFromSuperview];
        [_collectionView release];
        _collectionView = nil;
    }
}

- (void)loadPhotoAccessErrorView
{
//	UIView *view = [self.view viewWithTag:kPhotoAccessErrorViewTag];
//    if (view != nil)
//    {
//        return;
//    }
//    
//    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    view.tag = kPhotoAccessErrorViewTag;
//    view.backgroundColor = PhotoAccessViewBackgroundColor;
//    UIView *accessView = [PHSavePhotoResultViewCtrl photoAccessErrorView];
//    accessView.frame = CGRectMake(0, 20, accessView.frame.size.width, accessView.frame.size.height);
//    [view addSubview:accessView];
//    
//    UIImage *imageBtnBgStretch = [getResource(@"/Utility/Contacts/contacts_btn_bg.png") stretchableImageWithLeftCapWidth:5 topCapHeight:0];
//    UIButton *btnCreate = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnCreate.frame = CGRectMake((SCREEN_WIDTH-236)/2, 350*iPhoneWidthScaleFactor, 236, 48);
//    [btnCreate setTitle:_(@"I know") forState:UIControlStateNormal];
//    [btnCreate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnCreate setBackgroundImage:imageBtnBgStretch forState:UIControlStateNormal];
//    [btnCreate addTarget:self action:@selector(removePhotoAccessErrorView:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:btnCreate];
//    
//    [self.view addSubview:view];
//    [view fadeIn:kAnimationDuration delegate:nil];
//    [view release];
}

- (void)removePhotoAccessErrorView:(id)sender
{
	if ([sender isKindOfClass:[UIView class]])
    {
//        [self loadTopBar];
        [[(UIView *)sender superview] fadeOut:kAnimationDuration delegate:nil];
    	[[(UIView *)sender superview] removeFromSuperview];
    }
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

#pragma mark - Notification

- (void)appDidEnterBackground
{
    [self removeCollectionView];
    
//    // 在ios5.x下，删除照片用不会自动reload
//    if (SYSTEM_VERSION < 6.0) {
//        [self cancelSelectAction:nil];
//    }
}

- (void)appWillEnterForeground
{
//    if (SYSTEM_VERSION >= 6.0) {
//        [self.tableView reloadData];
//    }
//    [self loadData];
}

- (void)assetsLibraryChangedNotification:(NSNotification *)notification
{
    NSLog(@"notification.userInfo:%@------------------------notification.object:%@", notification.userInfo, notification.object);
    [self removeCollectionView];
    
    [self loadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    PHImagePickerGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[PHImagePickerGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageWithCGImage:assetsGroup.posterImage];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    cell.countLabel.text = [NSString stringWithFormat:@"(%ld)", (long)assetsGroup.numberOfAssets];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 防止快速两次点击，打开两次
    NSLog(@"didSelectRowAtIndexPath================%ld, intervalTime:%f", (long)indexPath.row, [[NSDate date] timeIntervalSince1970] - _lastSelectedTime);
    if ([[NSDate date] timeIntervalSince1970] - _lastSelectedTime < 1.0) {
        return;
    }
    _lastSelectedTime = [[NSDate date] timeIntervalSince1970];
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    
    BOOL showsHeaderButton = ([self.delegate respondsToSelector:@selector(descriptionForSelectingAllAssets:)] && [self.delegate respondsToSelector:@selector(descriptionForDeselectingAllAssets:)]);
    
    BOOL showsFooterDescription = NO;
    
    switch(self.filterType) {
        case QBImagePickerFilterTypeAllAssets:
            showsFooterDescription = ([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfPhotos:numberOfVideos:)]);
            break;
        case QBImagePickerFilterTypeAllPhotos:
            showsFooterDescription = ([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfPhotos:)]);
            break;
        case QBImagePickerFilterTypeAllVideos:
            showsFooterDescription = ([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfVideos:)]);
            break;
    }
    
    // Title
    NSString *title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    CGRect frame = CGRectMake(SCREEN_WIDTH, STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - 150);
    [self removeCollectionView];
    _collectionView = [[PHAssetCollectionView alloc] initWithFrame:frame title:title];
    _collectionView.collectionViewDelegate = self;
    _collectionView.assetsGroup = assetsGroup;
    _collectionView.filterType = self.filterType;
    _collectionView.showsHeaderButton = showsHeaderButton;
    _collectionView.showsFooterDescription = showsFooterDescription;
    
    _collectionView.allowsMultipleSelection = self.allowsMultipleSelection;
    _collectionView.limitsMinimumNumberOfSelection = self.limitsMinimumNumberOfSelection;
    _collectionView.limitsMaximumNumberOfSelection = self.limitsMaximumNumberOfSelection;
    _collectionView.minimumNumberOfSelection = self.minimumNumberOfSelection;
    _collectionView.maximumNumberOfSelection = self.maximumNumberOfSelection;
    if (self.selectedAssets != nil) {
        _collectionView.selectedAssets = self.selectedAssets;
    }
    
    [_collectionView reloadData];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window) {
        [window addSubview:_collectionView];
    }
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame= _collectionView.frame;
                         frame.origin.x -= SCREEN_WIDTH;
                         _collectionView.frame = frame;
                     }
                     completion:nil];
}

#pragma mark - QBAssetCollectionViewControllerDelegate

- (void)addImagesThread:(id)sender
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSArray *assets = (NSArray *)sender;
    
    NSMutableArray *info = [NSMutableArray array];
    NSMutableArray * imageArray = [[NSMutableArray alloc] init];
    for(ALAsset *asset in assets) {
        NSLog(@"urls ===== %@", [asset valueForProperty:ALAssetPropertyURLs]);
        if ([asset valueForProperty:ALAssetPropertyURLs] != nil) {
            [info addObject:[self mediaInfoFromAsset:asset]];
            [imageArray addObject:[self fullResolutionImageFromALAsset:asset]];
        }
    }
    [self performSelectorOnMainThread:@selector(addImagesDone:) withObject:imageArray waitUntilDone:NO];
	[pool release];
}

- (void)addImagesDone:(id)sender{
    
    if (stop) {
        return;
    }
    
    [self removeCollectionView];
    
    NSArray *imageArray = (NSArray *)sender;
    
    //进入拼图界面
    ImagesCombineViewCtrl * imageCombineCtrl = [[ImagesCombineViewCtrl alloc] initWithImages:imageArray];
    imageCombineCtrl.delegate = self;
    [self.navigationController pushViewController:imageCombineCtrl animated:YES];
    [imageCombineCtrl release];
    [imageArray release];
    
	//[PHLabelMessage removeWaitMessageLabelInView:[[UIApplication sharedApplication] keyWindow]];
    [self stopThread];
}

- (void)stopThread
{
    stop = YES;
    if (checkThread) {
        [checkThread cancel];
        [checkThread release];
        checkThread = nil;
    }
}

//获取正常尺寸的图片
-(UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    //正常尺寸
    //    CGImageRef imgRef = [assetRep fullResolutionImage];
    //屏幕尺寸
    CGImageRef imgRef = [assetRep fullScreenImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:UIImageOrientationUp];
    return img;
}

#pragma mark - PHAssetCollectionViewDelegate

- (void)collectionViewSelect:(ALAsset *)asset selectedAssets:(NSMutableArray *)selectedAssets
{
    self.selectedAssets = selectedAssets;
    NSLog(@"selectedAssets count:%lu", (unsigned long)[self.selectedAssets count]);
    
    if ([asset valueForProperty:ALAssetPropertyURLs] != nil) {
        UIImage *image = [self fullResolutionImageFromALAsset:asset];
        if (image) {
            
            [self.selectedImageArray addObject:image];
        }
    }
    
    //底部的选择视图
    if (_selectView.listItems.count < 9) {
        UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
        if (image) {
            [_selectView.listItems addObject:image];
            [_selectView updateItems];
        }
    }
}

- (void)didSelectedItemOutOfBounds
{
//    [PHAlertMessage alertMessage:_(@"Dear, you can't select more photos than 9")
//                         title:_(@"Warm tip")
//             cancelButtonTitle:_(@"OK")
//             otherButtonTitles:nil];
}

#pragma mark - PHImageSelectVIewDelegate

- (void)didRemoveItemWithIndex:(int)index
{
    if (index < self.selectedAssets.count) {
        [self.selectedAssets removeObjectAtIndex:index];
    }
    
    if (index < self.selectedImageArray.count) {
        [self.selectedImageArray removeObjectAtIndex:index];
    }
}

#pragma mark - ImagesCombineViewCtrlDelegate

- (void)ImagesCombineViewCtrlDone:(ImagesCombineViewCtrl *)viewController image:(UIImage *)image{
    if (_delegate && [_delegate respondsToSelector:@selector(imagePickerController:collageImage:)])
    {
        [_delegate imagePickerController:self collageImage:image];
    }
}

@end
