//
//  PHImagePickerViewController.h
//  ImagesCombine
//
//  Created by ZZF on 13-8-28.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PHAssetCollectionViewDelegate.h"
#import "PHImageSelectView.h"
#import "ImagesCombineViewCtrl.h"

typedef enum {
    QBImagePickerFilterTypeAllAssets,
    QBImagePickerFilterTypeAllPhotos,
    QBImagePickerFilterTypeAllVideos
} QBImagePickerFilterType;

@class PHImagePickerViewCtrl;

@protocol PHImagePickerViewCtrlDelegate <NSObject>

@optional
- (void)imagePickerControllerWillFinishPickingMedia:(PHImagePickerViewCtrl *)imagePickerController;
- (void)imagePickerController:(PHImagePickerViewCtrl *)imagePickerController didFinishPickingMediaWithInfo:(id)info;
- (void)imagePickerControllerDidCancel:(PHImagePickerViewCtrl *)imagePickerController;
- (NSString *)descriptionForSelectingAllAssets:(PHImagePickerViewCtrl *)imagePickerController;
- (NSString *)descriptionForDeselectingAllAssets:(PHImagePickerViewCtrl *)imagePickerController;
- (NSString *)imagePickerController:(PHImagePickerViewCtrl *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos;
- (NSString *)imagePickerController:(PHImagePickerViewCtrl *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos;
- (NSString *)imagePickerController:(PHImagePickerViewCtrl *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos;
- (void)imagePickerController:(PHImagePickerViewCtrl *)imagePickerController collageImage:(UIImage *)image;

@end

@interface PHImagePickerViewCtrl : UIViewController <UITableViewDataSource, UITableViewDelegate,
                                                        PHImageSelectVIewDelegate, ImagesCombineViewCtrlDelegate,
                                                        PHAssetCollectionViewDelegate>
{
    NSThread *checkThread;
    BOOL stop;
}

@property (nonatomic, assign) id<PHImagePickerViewCtrlDelegate> delegate;
@property (nonatomic, assign) QBImagePickerFilterType filterType;
@property (nonatomic, assign) BOOL showsCancelButton;

@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL limitsMinimumNumberOfSelection;
@property (nonatomic, assign) BOOL limitsMaximumNumberOfSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
@property (nonatomic, retain) NSMutableArray *selectedAssets;

@end
