//
//  PHAssetCollectionView.m
//  ImagesCombine
//
//  Created by leihui on 13-12-2.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import "PHAssetCollectionView.h"
#import "PHImagePickerAssetCell.h"
#import "PHImagePickerFooterView.h"
#import <QuartzCore/QuartzCore.h>

NSString *kUpdateAssetsCollectionViewNotification = @"kUpdateAssetsCollectionViewNotification";

@interface PHAssetCollectionView ()

@property (nonatomic, retain) NSMutableArray *assets;
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation PHAssetCollectionView

@synthesize collectionViewDelegate = _collectionViewDelegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.assets = [NSMutableArray array];
        self.selectedAssets = [NSMutableArray array];
        self.imageSize = CGSizeMake(100, 100);
        
        [self initNavigationBar:title];
        [self initTableView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionView:) name:kUpdateAssetsCollectionViewNotification object:nil];
    }
    return self;
}

#pragma mark - Private

- (void)initNavigationBar:(NSString *)title
{
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, NAVIGATIONBAR_HEIGHT)];
    
    // Background
    UIImage *backgroundImage = [getResource(@"Common/Bar/NavBarBackground.png") stretchableImageWithLeftCapWidth:1 topCapHeight:22];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:navBar.bounds];
    backgroundImageView.image = backgroundImage;
    [navBar addSubview:backgroundImageView];
    [backgroundImageView release];
    
    // Back button
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 57.0, 44.0);
    btnBack.showsTouchWhenHighlighted = YES;
    UIImage *image = getResource(@"Common/Bar/BackItem.png");
    [btnBack setImage:image forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:btnBack];
    
    // Line
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(btnBack.frame.size.width-1, 9, 1, 25)];
    line.image = getResource(@"Common/Bar/TopBarLine.png");
    [btnBack addSubview:line];
    [line release];
    
    // Title
    CGFloat titleHeight = 25.f;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, (NAVIGATIONBAR_HEIGHT - titleHeight)/2, 200, titleHeight)];
    label.text = title;
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    [navBar addSubview:label];
    [label release];
    
    [self addSubview:navBar];
    [navBar release];
}

- (void)initTableView
{
    // Table View
    CGRect tableRect = CGRectMake(0, NAVIGATIONBAR_HEIGHT, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-NAVIGATIONBAR_HEIGHT);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = YES;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:tableView];
    self.tableView = tableView;
    [tableView release];
}

- (void)backAction:(id)sender
{
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame= self.frame;
                         frame.origin.x += SCREEN_WIDTH;
                         self.frame =frame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)reloadData
{
    // Reload assets
    [self.assets removeAllObjects];
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result) {
            [self.assets addObject:result];
        }
    }];
    
    [self.tableView reloadData];
    
    // Set footer view
    if(self.showsFooterDescription) {
        [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
//        NSUInteger numberOfPhotos = self.assetsGroup.numberOfAssets;
        
        [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
//        NSUInteger numberOfVideos = self.assetsGroup.numberOfAssets;
        
        switch(self.filterType) {
            case QBImagePickerFilterTypeAllAssets:
                [self.assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
                break;
            case QBImagePickerFilterTypeAllPhotos:
                [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                break;
            case QBImagePickerFilterTypeAllVideos:
                [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
                break;
        }
        
        PHImagePickerFooterView *footerView = [[PHImagePickerFooterView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 48)];
        
        if(self.filterType == QBImagePickerFilterTypeAllAssets) {
//            footerView.titleLabel.text = [self.delegate assetCollectionViewController:nil descriptionForNumberOfPhotos:numberOfPhotos numberOfVideos:numberOfVideos];
        } else if(self.filterType == QBImagePickerFilterTypeAllPhotos) {
//            footerView.titleLabel.text = [self.delegate assetCollectionViewController:nil descriptionForNumberOfPhotos:numberOfPhotos];
        } else if(self.filterType == QBImagePickerFilterTypeAllVideos) {
//            footerView.titleLabel.text = [self.delegate assetCollectionViewController:nil descriptionForNumberOfVideos:numberOfVideos];
        }
        
//        footerView.titleLabel.text = @"Text for footer...";
        
        self.tableView.tableFooterView = footerView;
        [footerView release];
    }
    else {
        PHImagePickerFooterView *footerView = [[PHImagePickerFooterView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 4)];
        
        self.tableView.tableFooterView = footerView;
        [footerView release];
    }
}

#pragma mark- Notification

- (void)updateCollectionView:(NSNotification *)notification
{
//    id object = notification.object;
//    if (object && [object isKindOfClass:[ALAssetsGroup class]]) {
//        self.assetsGroup = object;
//        
//        [self reloadData];
//    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = 0;
    
    switch(section) {
        case 0: case 1:
        {
            if(self.allowsMultipleSelection && !self.limitsMaximumNumberOfSelection && self.showsHeaderButton) {
                numberOfRowsInSection = 1;
            }
        }
            break;
        case 2:
        {
            NSInteger numberOfAssetsInRow = self.bounds.size.width / self.imageSize.width;
            numberOfRowsInSection = self.assets.count / numberOfAssetsInRow;
            if((self.assets.count - numberOfRowsInSection * numberOfAssetsInRow) > 0) numberOfRowsInSection++;
        }
            break;
    }
    
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch(indexPath.section) {
        case 0:
        {
            NSString *cellIdentifier = @"HeaderCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if(cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            
            if(self.selectedAssets.count == self.assets.count) {
                // Set accessory view
                UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
                accessoryView.image = [UIImage imageNamed:@"Resource/Image/ImageCombine/minus.png"];
                
                accessoryView.layer.shadowColor = [[UIColor colorWithWhite:0 alpha:1.0] CGColor];
                accessoryView.layer.shadowOpacity = 0.70;
                accessoryView.layer.shadowOffset = CGSizeMake(0, 1.4);
                accessoryView.layer.shadowRadius = 2;
                
                cell.accessoryView = accessoryView;
                [accessoryView release];
            } else {
                // Set accessory view
                UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
                accessoryView.image = [UIImage imageNamed:@"Resource/Image/ImageCombine/plus.png"];
                
                accessoryView.layer.shadowColor = [[UIColor colorWithWhite:0 alpha:1.0] CGColor];
                accessoryView.layer.shadowOpacity = 0.70;
                accessoryView.layer.shadowOffset = CGSizeMake(0, 1.4);
                accessoryView.layer.shadowRadius = 2;
                
                cell.accessoryView = accessoryView;
                [accessoryView release];
            }
        }
            break;
        case 1:
        {
            NSString *cellIdentifier = @"SeparatorCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if(cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                // Set background view
                UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
                backgroundView.backgroundColor = [UIColor colorWithWhite:0.878 alpha:1.0];
                
                cell.backgroundView = backgroundView;
                [backgroundView release];
            }
        }
            break;
        case 2:
        {
            NSString *cellIdentifier = @"AssetCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if(cell == nil) {
                NSInteger numberOfAssetsInRow = self.bounds.size.width / self.imageSize.width;
                CGFloat margin = round((self.bounds.size.width - self.imageSize.width * numberOfAssetsInRow) / (numberOfAssetsInRow + 1));
                
                cell = [[[PHImagePickerAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier imageSize:self.imageSize numberOfAssets:numberOfAssetsInRow margin:margin] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [(PHImagePickerAssetCell *)cell setDelegate:self];
                [(PHImagePickerAssetCell *)cell setAllowsMultipleSelection:self.allowsMultipleSelection];
            }
            
            // Set assets
            NSInteger numberOfAssetsInRow = self.bounds.size.width / self.imageSize.width;
            NSInteger offset = numberOfAssetsInRow * indexPath.row;
            NSInteger numberOfAssetsToSet = (offset + numberOfAssetsInRow > self.assets.count) ? (self.assets.count - offset) : numberOfAssetsInRow;
            
            NSMutableArray *assets = [NSMutableArray array];
            for(NSUInteger i = 0; i < numberOfAssetsToSet; i++) {
                ALAsset *asset = [self.assets objectAtIndex:(offset + i)];
                
                [assets addObject:asset];
            }
            
            [(PHImagePickerAssetCell *)cell setAssets:assets];
            
        }
            break;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 0;
    
    switch(indexPath.section) {
        case 0:
        {
            heightForRow = 44;
        }
            break;
        case 1:
        {
            heightForRow = 1;
        }
            break;
        case 2:
        {
            NSInteger numberOfAssetsInRow = self.bounds.size.width / self.imageSize.width;
            CGFloat margin = round((self.bounds.size.width - self.imageSize.width * numberOfAssetsInRow) / (numberOfAssetsInRow + 1));
            heightForRow = margin + self.imageSize.height;
        }
            break;
    }
    
    return heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0) {
        if(self.selectedAssets.count == self.assets.count) {
            // Deselect all assets
            [self.selectedAssets removeAllObjects];
        } else {
            // Select all assets
            [self.selectedAssets addObjectsFromArray:self.assets];
        }
        
        // Set done button state
//        [self updateDoneButton];
        
        // Update assets
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        
        // Update header text
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        // Cancel table view selection
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - PHImagePickerAssetCellDelegate

- (BOOL)assetCell:(PHImagePickerAssetCell *)assetCell canSelectAssetAtIndex:(NSUInteger)index
{
    BOOL canSelect = YES;
    
    if(self.allowsMultipleSelection && self.limitsMaximumNumberOfSelection) {
        canSelect = (self.selectedAssets.count < self.maximumNumberOfSelection);
    }
    
    return canSelect;
}

- (void)assetCell:(PHImagePickerAssetCell *)assetCell didChangeAssetSelectionState:(BOOL)selected atIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:assetCell];
    
    NSInteger numberOfAssetsInRow = self.bounds.size.width / self.imageSize.width;
    NSInteger assetIndex = indexPath.row * numberOfAssetsInRow + index;
    ALAsset *asset = [self.assets objectAtIndex:assetIndex];
    
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullScreenImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:UIImageOrientationUp];
    
    NSLog(@"img.size-----[%f, %f]", img.size.width, img.size.height);
    if (img.size.width == 0.f) {
        return;
    }
    
    if(self.allowsMultipleSelection) {
        
        if (self.collectionViewDelegate && [self.collectionViewDelegate respondsToSelector:@selector(collectionViewSelect:selectedAssets:)]) {
            if ([self.selectedAssets count] >= 9) {
                [self.collectionViewDelegate didSelectedItemOutOfBounds];
            }
            else {
                [self.selectedAssets addObject:asset];
                [self.collectionViewDelegate collectionViewSelect:asset selectedAssets:self.selectedAssets];
            }
        }
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.assetsGroup = nil;
    self.selectedAssets = nil;
    self.assets = nil;
    self.tableView = nil;
    
    [super dealloc];
}

@end
