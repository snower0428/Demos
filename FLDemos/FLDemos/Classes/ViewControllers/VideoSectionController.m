//
//  VideoSectionController.m
//  FLDemos
//
//  Created by leihui on 2020/2/10.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "VideoSectionController.h"
#import "VideoCollectionViewCell.h"
#import "VideoDetailSectionModel.h"

@interface VideoSectionController () <IGListScrollDelegate, IGListDisplayDelegate>

@property (nonatomic, strong) VideoDetailSectionModel *sectionModel;

@end

@implementation VideoSectionController

- (instancetype)init {
    if (self = [super init]) {
        // Init
        self.scrollDelegate = self;
        self.displayDelegate = self;
    }
    return self;
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
//    NSLog(@"cell:%zd", index);
    UICollectionViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:VideoCollectionViewCell.class
                                                               forSectionController:self
                                                                            atIndex:index];
    if (cell && [cell isKindOfClass:[VideoCollectionViewCell class]]) {
        if (self.sectionModel != NULL) {
            VideoCollectionViewCell *videoCell = (VideoCollectionViewCell *)cell;
            if (index < _sectionModel.arrayData.count) {
                VideoDetailItem *item = [_sectionModel.arrayData objectAtIndex:index];
                [videoCell setImageWithUrl:item.previewUrl];
//                [videoCell playVideoWithUrl:item.videoUrl];
            }
        }
    }
    return cell;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (NSInteger)numberOfItems {
    return _sectionModel.arrayData.count;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"index:%@", @(index));
}

- (void)didUpdateToObject:(id)object {
    self.sectionModel = object;
}

#pragma mark - IGListScrollDelegate

- (void)listAdapter:(IGListAdapter *)listAdapter didScrollSectionController:(IGListSectionController *)sectionController {
    //NSLog(@"didScrollSectionController");
}

- (void)listAdapter:(IGListAdapter *)listAdapter willBeginDraggingSectionController:(IGListSectionController *)sectionController {
    //NSLog(@"willBeginDraggingSectionController");
}

- (void)listAdapter:(IGListAdapter *)listAdapter didEndDraggingSectionController:(IGListSectionController *)sectionController willDecelerate:(BOOL)decelerate {
    //NSLog(@"didEndDraggingSectionController %@", @(decelerate));
}

- (void)listAdapter:(IGListAdapter *)listAdapter didEndDeceleratingSectionController:(IGListSectionController *)sectionController {
    //NSLog(@"didEndDeceleratingSectionController");
    
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = listAdapter.collectionView.contentOffset;
    visibleRect.size = listAdapter.collectionView.bounds.size;
    CGPoint visiblePoint = CGPointMake(visibleRect.origin.x + visibleRect.size.width / 2, visibleRect.origin.y + visibleRect.size.height / 2);
    NSIndexPath *indexPath = [listAdapter.collectionView indexPathForItemAtPoint:visiblePoint];
    NSLog(@"indexPath:%@, item:%@", indexPath, @(indexPath.item));
    
    NSInteger index = indexPath.item;
    UICollectionViewCell *cell = [listAdapter.collectionView cellForItemAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:[VideoCollectionViewCell class]]) {
            if (self.sectionModel != NULL) {
                VideoCollectionViewCell *videoCell = (VideoCollectionViewCell *)cell;
                if (index < _sectionModel.arrayData.count) {
                    VideoDetailItem *item = [_sectionModel.arrayData objectAtIndex:index];
//                    [videoCell setImageWithUrl:item.previewUrl];
                    [videoCell playVideoWithUrl:item.videoUrl];
                }
            }
        }
}

#pragma mark - IGListDisplayDelegate <NSObject>

- (void)listAdapter:(IGListAdapter *)listAdapter willDisplaySectionController:(IGListSectionController *)sectionController {
    //NSLog(@"willDisplaySectionController");
}

- (void)listAdapter:(IGListAdapter *)listAdapter didEndDisplayingSectionController:(IGListSectionController *)sectionController {
    //NSLog(@"didEndDisplayingSectionController");
}

- (void)listAdapter:(IGListAdapter *)listAdapter willDisplaySectionController:(IGListSectionController *)sectionController
               cell:(UICollectionViewCell *)cell
            atIndex:(NSInteger)index {
    //NSLog(@"willDisplaySectionController index:%zd", index);
}

- (void)listAdapter:(IGListAdapter *)listAdapter didEndDisplayingSectionController:(IGListSectionController *)sectionController
               cell:(UICollectionViewCell *)cell
            atIndex:(NSInteger)index {
    //NSLog(@"didEndDisplayingSectionController index:%zd", index);
}

@end
