//
//  SimpleRollLayout.m
//  UICollectionViewDemo
//
//  Created by leihui on 17/1/4.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "SimpleRollLayout.h"

@implementation SimpleRollLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSMutableArray *attributesArray = [NSMutableArray array];
	NSInteger itemCounts = [self.collectionView numberOfItemsInSection:0];
	
	for (NSInteger i = 0; i < itemCounts; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
		[attributesArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
	}
	
	return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger itemCounts = [self.collectionView numberOfItemsInSection:0];
	
	UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
	attributes.size = CGSizeMake(260.f, 100.f);
	attributes.center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
	
	/**
	 *	创建一个transform3D类，CATransform3D是一个类似矩阵的结构体
	 *	CATransform3DIdentity创建空的矩阵
	 */
	CATransform3D transform3D = CATransform3DIdentity;
	// 这个值设置的是透视度，影响视觉离投影平面的距离
	transform3D.m34 = -1/900.f;
	
	// 这个是3D滚轮的半径
	CGFloat radius = (attributes.size.height/2) / tanf((2*M_PI/itemCounts)/2);
	
	// 获取当前偏移量
	CGFloat offset = self.collectionView.contentOffset.y;
	// 在角度设置上，添加一个偏移角度
	CGFloat angleOffset = offset/self.collectionView.frame.size.height;
	
	// 每个Item旋转的角度
	CGFloat angle = (CGFloat)(indexPath.row+angleOffset-1)/itemCounts*M_PI*2;
	
	transform3D = CATransform3DRotate(transform3D, angle, 1.0, 0, 0);
	attributes.transform3D = transform3D;
	
	transform3D = CATransform3DTranslate(transform3D, 0, 0, radius);
	attributes.transform3D = transform3D;
	
	attributes.center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2+self.collectionView.contentOffset.y);
	
	return attributes;
}

- (CGSize)collectionViewContentSize
{
	NSInteger itemCounts = [self.collectionView numberOfItemsInSection:0];
	return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height*(itemCounts+2));
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
	return YES;
}

@end
