//
//  PHImagePickerFooterView.m
//  ImagesCombine
//
//  Created by ZZF on 13-8-28.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import "PHImagePickerFooterView.h"

@implementation PHImagePickerFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        /* Initialization */
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithRed:0.502 green:0.533 blue:0.58 alpha:1.0];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel release];
    }
    
    return self;
}

- (void)dealloc
{
    [_titleLabel release];
    
    [super dealloc];
}

@end
