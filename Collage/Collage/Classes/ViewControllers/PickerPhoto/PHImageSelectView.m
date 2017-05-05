//
//  PHImageSelectView.m
//  ImagesCombine
//
//  Created by ZZF on 13-8-28.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import "PHImageSelectView.h"

@implementation PHImageSelectView

@synthesize listItems = _listItems;
@synthesize delegate = _delegate;

- (void)dealloc
{    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor grayColor];
        
        CGFloat topHeight = 42.f;
        
        // Top background
        UIImage *topImage = getResource(@"ImageCombine/top_bg.png");
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, topHeight)];
        topImageView.image = topImage;
        [self addSubview:topImageView];
        [topImageView release];
        
        // List background
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, topHeight, frame.size.width, 110)];
        bg.image = getResource(@"ImageCombine/selected_list_bg.png");
        [self addSubview:bg];
        [bg release];
        
        // Label
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, frame.size.width, topHeight)];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.font = [UIFont systemFontOfSize:14];
        numLabel.textAlignment = UITextAlignmentLeft;
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.text = [NSString stringWithFormat:_(@"Selected %d photo(maximum 9)"), 0];
        [self addSubview:numLabel];
        [numLabel release];
        
        self.listItems = [[[NSMutableArray alloc] init] autorelease];
        imageScrollView = [[PHImageScrollView alloc] initWithFrame:CGRectMake(0, 45, frame.size.width, 100) items:_listItems];
        imageScrollView.delegate = self;
        [self addSubview:imageScrollView];
        [imageScrollView release];
    }
    return self;
}

- (void)removeAllItems
{
    if ([_listItems count] > 0) {
        [_listItems removeAllObjects];
    }
    
    [imageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)updateItems{
    numLabel.text = [NSString stringWithFormat:_(@"Selected %d photo(maximum 9)"), _listItems.count];
    [imageScrollView updateItems:_listItems];
}

#pragma mark - PHImageScrollViewDelegate

- (void)didRemoveItemWithIndex:(int)index{
    if (index < _listItems.count) {
        [_listItems removeObjectAtIndex:index];
        [self updateItems];
        
        if (_delegate && [_delegate respondsToSelector:@selector(didRemoveItemWithIndex:)]){
            [_delegate didRemoveItemWithIndex:index];
        }
    }
}

@end
