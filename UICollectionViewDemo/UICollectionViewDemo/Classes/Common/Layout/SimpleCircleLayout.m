//
//  SimpleCircleLayout.m
//  UICollectionViewDemo
//
//  Created by leihui on 17/1/4.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "SimpleCircleLayout.h"

@interface SimpleCircleLayout ()

@property (nonatomic, strong) NSMutableArray *attributesArray;

@end

@implementation SimpleCircleLayout

- (void)prepareLayout
{
	[super prepareLayout];
	
	self.attributesArray = [NSMutableArray array];
	
	CGFloat radius = MIN(self.collectionView.frame.size.width, self.collectionView.frame.size.height)/2;
	CGPoint center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
	
	_itemCount = [self.collectionView numberOfItemsInSection:0];
	
	for (NSInteger i = 0; i < _itemCount ; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
		UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
		attributes.size = CGSizeMake(50.f, 50.f);
		
		// 计算每个Item的圆心位置，算出的x,y还要减去自身半径大小
		CGFloat x = center.x + cosf(2*M_PI/_itemCount*i)*(radius-25);
		CGFloat y = center.y + sinf(2*M_PI/_itemCount*i)*(radius-25);
		
		attributes.center = CGPointMake(x, y);
		[_attributesArray addObject:attributes];
		
		NSLog(@"center:%@", NSStringFromCGPoint(attributes.center));
	}
}

- (CGSize)collectionViewContentSize
{
	return self.collectionView.frame.size;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
	return _attributesArray;
}

@end
