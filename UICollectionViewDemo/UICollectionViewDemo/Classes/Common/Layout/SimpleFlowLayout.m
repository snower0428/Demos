//
//  SimpleFlowLayout.m
//  UICollectionViewDemo
//
//  Created by leihui on 17/1/4.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "SimpleFlowLayout.h"

@interface SimpleFlowLayout ()

@property (nonatomic, strong) NSMutableArray *attributesArray;

@end

@implementation SimpleFlowLayout

- (void)prepareLayout
{
	[super prepareLayout];
	
	self.attributesArray = [NSMutableArray array];
	
	CGFloat width = (SCREEN_WIDTH - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing)/2;
	CGFloat colHeight[2] = {self.sectionInset.top, self.sectionInset.bottom};
	
	for (NSInteger i = 0; i < _itemCount; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
		UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
		
		CGFloat height = arc4random()%150 + 40;
		
		// 标记最短的列，将新的Item高度加入到短的一列
		NSInteger col = 0;
		if (colHeight[0] <= colHeight[1]) {
			colHeight[0] = colHeight[0] + height + self.minimumLineSpacing;
			col = 0;
		}
		else {
			colHeight[1] = colHeight[1] + height + self.minimumLineSpacing;
			col = 1;
		}
		
		CGFloat leftMargin = self.sectionInset.left + (self.minimumInteritemSpacing + width)*col;
		CGFloat topMargin = colHeight[col] - height - self.minimumLineSpacing;
		
		attributes.frame = CGRectMake(leftMargin, topMargin, width, height);
		[_attributesArray addObject:attributes];
	}
	
	if (colHeight[0] > colHeight[1]) {
		self.itemSize = CGSizeMake(width, (colHeight[0] - self.sectionInset.top)*2/_itemCount - self.minimumLineSpacing);
	}
	else {
		self.itemSize = CGSizeMake(width, (colHeight[1] - self.sectionInset.top)*2/_itemCount - self.minimumLineSpacing);
	}
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
	return _attributesArray;
}

@end
