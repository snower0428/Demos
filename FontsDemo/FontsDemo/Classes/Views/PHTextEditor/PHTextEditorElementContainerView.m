//
//  PHTextEditorElementContainerView.m
//  InstaSave
//
//  Created by leihui on 16/12/28.
//  Copyright © 2016年 ~. All rights reserved.
//

#import "PHTextEditorElementContainerView.h"
#import "PHTextEditorFontView.h"
#import "PHTextEditorFontColorView.h"

@interface PHTextEditorElementContainerView () <PHTextEditorFontViewDelegate, PHTextEditorFontColorViewDelegate>

@property (nonatomic, strong) UIButton *btnFont;
@property (nonatomic, strong) UIButton *btnFontColor;
@property (nonatomic, strong) PHTextEditorFontView *fontView;
@property (nonatomic, strong) PHTextEditorFontColorView *fontColorView;

@end

@implementation PHTextEditorElementContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Init
		self.fontView = [[PHTextEditorFontView alloc] initWithFrame:self.bounds];
		_fontView.backgroundColor = [UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
		_fontView.delegate = self;
		[self addSubview:_fontView];
		
		self.fontColorView = [[PHTextEditorFontColorView alloc] initWithFrame:self.bounds];
		_fontColorView.backgroundColor = [UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
		_fontColorView.delegate = self;
		[self addSubview:_fontColorView];
	}
	
	return self;
}

- (void)frontViewWithAction:(PHTextEditorToolBarAction)action
{
	if (action == PHTextEditorToolBarActionFont) {
		[self bringSubviewToFront:_fontView];
	}
	else if (action == PHTextEditorToolBarActionFontColor) {
		[self bringSubviewToFront:_fontColorView];
	}
}

#pragma mark - PHTextEditorFontViewDelegate

- (void)didSelectedFont:(NSString *)fontName
{
	if (_delegate && [_delegate respondsToSelector:@selector(didSelectedFont:)]) {
		[_delegate didSelectedFont:fontName];
	}
}

#pragma mark - PHTextEditorFontColorViewDelegate

- (void)didSelectedColor:(UIColor *)color
{
	if (_delegate && [_delegate respondsToSelector:@selector(didSelectedColor:)]) {
		[_delegate didSelectedColor:color];
	}
}

@end
