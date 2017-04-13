//
//  PHTextEditorFontColorView.m
//  InstaSave
//
//  Created by leihui on 16/12/29.
//  Copyright © 2016年 ~. All rights reserved.
//

#import "PHTextEditorFontColorView.h"

#define kColorButtonBaseTag		1612291800

@interface PHTextEditorFontColorView ()

@property (nonatomic, retain) NSArray *arrayColor;
@property (nonatomic, retain) UIColor *currentSelectedColor;
@property (nonatomic, assign) NSInteger lastSelectedColorIndex;

@end

@implementation PHTextEditorFontColorView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Init
		[self loadColor];
		[self createViews];
	}
	
	return self;
}

#pragma mark - Private

- (void)loadColor
{
	self.arrayColor = @[RGB(255,45,81),
						RGB(255,56,232),
						RGB(200,58,245),
						RGB(139,60,245),
						RGB(71,61,244),
						RGB(48,92,244),
						RGB(33,171,248),
						RGB(0,241,250),
						RGB(0,254,217),
						RGB(57,235,89),
						RGB(66,212,87),
						RGB(151,250,95),
						RGB(230,250,96),
						RGB(255,221,89),
						RGB(255,139,70),
						RGB(255,69,59),
						RGB(255,255,255),
						RGB(198,198,198),
						RGB(145,145,145),
						RGB(94,94,94),
						RGB(47,47,47),
						RGB(1,1,1)];
}

- (void)createViews
{
	NSInteger numberOfColors = [_arrayColor count];
	NSInteger numberOfItemsPerLine = 10;
	NSInteger numberOfLines = 0;
	if (numberOfColors%numberOfItemsPerLine == 0) {
		numberOfLines = numberOfColors/numberOfItemsPerLine;
	}
	else {
		numberOfLines = numberOfColors/numberOfItemsPerLine + 1;
	}
	CGFloat btnWidth = SCREEN_WIDTH/numberOfItemsPerLine;
	CGFloat btnHeight = btnWidth;
	
	CGFloat leftMargin = 0.f;
	CGFloat topMargin = (self.frame.size.height-btnHeight*numberOfLines)/2;
	
	for (NSInteger i = 0; i < numberOfColors; i++) {
		CGRect colorButtonFrame = CGRectMake(leftMargin+btnWidth*(i%numberOfItemsPerLine), topMargin+btnHeight*(i/numberOfItemsPerLine), btnWidth, btnHeight);
		
		UIButton *btnColor = [UIButton buttonWithType:UIButtonTypeCustom];
		btnColor.backgroundColor = _arrayColor[i];
		btnColor.frame = colorButtonFrame;
		btnColor.tag = kColorButtonBaseTag+i;
		[self addSubview:btnColor];
		[btnColor addTarget:self action:@selector(selectedColorAction:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (void)selectedColorAction:(id)sender
{
	NSInteger numberOfColors = [_arrayColor count];
	NSInteger index = ((UIButton *)sender).tag - kColorButtonBaseTag;
	if (index < numberOfColors) {
		self.currentSelectedColor = _arrayColor[index];
		if (_lastSelectedColorIndex >= 0) {
			UIButton *btnLast = (UIButton *)[self viewWithTag:kColorButtonBaseTag+_lastSelectedColorIndex];
			if (btnLast) {
				btnLast.layer.borderColor = [UIColor clearColor].CGColor;
			}
		}
		_lastSelectedColorIndex = index;
		
		UIButton *btnCurrent = (UIButton *)[self viewWithTag:kColorButtonBaseTag+index];
		if (btnCurrent) {
			btnCurrent.layer.borderWidth = 2.f;
			if (index == numberOfColors-1) {
				btnCurrent.layer.borderColor = [UIColor whiteColor].CGColor;
			}
			else {
				btnCurrent.layer.borderColor = [UIColor blackColor].CGColor;
			}
		}
		
		if (_currentSelectedColor) {
			if (_delegate && [_delegate respondsToSelector:@selector(didSelectedColor:)]) {
				[_delegate didSelectedColor:_currentSelectedColor];
			}
		}
	}
}

@end
