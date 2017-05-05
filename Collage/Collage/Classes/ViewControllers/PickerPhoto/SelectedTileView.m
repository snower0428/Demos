//
//  SelectedTileView.m
//  91Home
//
//  Created by leihui on 13-12-5.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#import "SelectedTileView.h"

@interface SelectedTileView ()
{
    UIImageView     *_imageView;
}

@end

@implementation SelectedTileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
        
        UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.frame = CGRectMake(-2, -2, 25, 25);
        [btnDelete setBackgroundImage:getResource(@"ImageCombine/closeBtn.png") forState:UIControlStateNormal];
		[btnDelete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnDelete];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [self initWithFrame:frame];
    if (self) {
        // Init
        _imageView.image = image;
    }
    return self;
}

- (void)setTileImage:(UIImage *)image
{
    _imageView.image = image;
}

- (void)deleteAction:(id)sender
{
    
}

#pragma mark - dealloc

- (void)dealloc
{
    [_imageView release];
    
    [super dealloc];
}

@end
