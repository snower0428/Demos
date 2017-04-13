//
//  PHTextEditorToolbar.m
//  InstaSave
//
//  Created by leihui on 16/12/28.
//  Copyright © 2016年 ~. All rights reserved.
//

#import "PHTextEditorToolbar.h"
#import "PHTextEditorDefines.h"

@implementation PHTextEditorToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Init
		CGFloat leftMargin = 20.f*iPhoneWidthScaleFactor;
		CGFloat width = 80.f*iPhoneWidthScaleFactor;
		CGFloat xInterval = 20.f*iPhoneWidthScaleFactor;
		
		NSArray *array = @[@"键盘", @"字体", @"颜色"];
		for (NSInteger i = 0; i < 3; i++) {
			CGRect btnFrame = CGRectMake(leftMargin+(width+xInterval)*i, 0.f, width, frame.size.height);
			
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.tag = PHTextEditorToolBarActionKeyboard+i;
			button.frame = btnFrame;
			if (i < [array count]) {
				NSString *title = array[i];
				[button setTitle:title forState:UIControlStateNormal];
			}
			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
			[self addSubview:button];
			[button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
		}
	}
	
	return self;
}

#pragma mark - Public

- (void)enabledToolbar:(BOOL)bEnable
{
	for (NSInteger i = 0; i < 2; i++) {
		UIButton *button = (UIButton *)[self viewWithTag:PHTextEditorToolBarActionFont+i];
		if (button) {
			button.enabled = bEnable;
		}
	}
}

#pragma mark - Actions

- (void)btnAction:(id)sender
{
	NSInteger btnTag = ((UIButton *)sender).tag;
	switch (btnTag) {
		case PHTextEditorToolBarActionKeyboard:
		{
			if (_delegate && [_delegate respondsToSelector:@selector(didSelectedKeyboard)]) {
				[_delegate didSelectedKeyboard];
			}
			break;
		}
		case PHTextEditorToolBarActionFont:
		{
			if (_delegate && [_delegate respondsToSelector:@selector(didSelectedFont)]) {
				[_delegate didSelectedFont];
			}
			break;
		}
		case PHTextEditorToolBarActionFontColor:
		{
			if (_delegate && [_delegate respondsToSelector:@selector(didSelectedFontColor)]) {
				[_delegate didSelectedFontColor];
			}
			break;
		}
		default:
			break;
	}
}

@end
