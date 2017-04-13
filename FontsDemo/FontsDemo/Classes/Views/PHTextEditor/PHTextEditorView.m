//
//  PHTextEditorView.m
//  InstaSave
//
//  Created by leihui on 16/12/28.
//  Copyright © 2016年 ~. All rights reserved.
//

#import "PHTextEditorView.h"

#define kControlSize		20.f
#define kMaxFontSize		200.f

CG_INLINE CGPoint CGRectGetCenter(CGRect rect)
{
	return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CG_INLINE CGFloat CGPointGetDistance(CGPoint point1, CGPoint point2)
{
	//Saving Variables.
	CGFloat fx = (point2.x - point1.x);
	CGFloat fy = (point2.y - point1.y);
	
	return sqrt((fx*fx + fy*fy));
}

CG_INLINE CGFloat CGAffineTransformGetAngle(CGAffineTransform t)
{
	return atan2(t.b, t.a);
}

@interface PHTextEditorView () <UITextViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *deleteControl;
@property (nonatomic, strong) UIImageView *resizingControl;

@property (nonatomic, assign) CGPoint prevPoint;
@property (nonatomic, assign) CGPoint touchLocation;

@property (nonatomic, assign) CGPoint beginningPoint;
@property (nonatomic, assign) CGPoint beginningCenter;

@property (nonatomic, assign) CGRect beginBounds;

@property (nonatomic, assign) CGRect initialBounds;
@property (nonatomic, assign) CGFloat initialDistance;

@property (nonatomic, assign) CGFloat deltaAngle;

@property (nonatomic, assign) BOOL isDeleting;

@property (nonatomic, strong) NSString *defaultText;

@end

@implementation PHTextEditorView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Init
		self.defaultText = _(@"Click to enter");
		self.minSize = CGSizeMake(kControlSize*3, kControlSize*3);
		if (self.minSize.height >  frame.size.height ||
			self.minSize.width  >  frame.size.width  ||
			self.minSize.height <= 0 || self.minSize.width <= 0) {
			self.minSize = CGSizeMake(frame.size.width/3.f, frame.size.height/3.f);
		}
		
		UIFont *font = [UIFont systemFontOfSize:14.f];
		self.minFontSize = font.pointSize;
		self.curFont = font;
		
		[self createControls];
		[self createTextView];
		[self centerTextVertically];
	}
	
	return self;
}

#pragma mark - Public

- (void)setCurFont:(UIFont *)curFont
{
	_curFont = curFont;
	
	CGFloat cFont = self.textView.font.pointSize;
	CGSize  tSize = [self textSizeWithFont:cFont text:nil];
	
	BOOL isBeyondSize = [self isBeyondSize:tSize];
	if (isBeyondSize)
	{
		do {
			tSize = [self textSizeWithFont:--cFont text:nil];
		}
		while ([self isBeyondSize:tSize] && cFont > 0);
		[self.textView setFont:[self.curFont fontWithSize:cFont]];
	}
	else
	{
		do
		{
			tSize = [self textSizeWithFont:++cFont text:nil];
		}
		while (![self isBeyondSize:tSize] && cFont < kMaxFontSize);
		cFont = (cFont < kMaxFontSize) ? cFont : self.minFontSize;
		[self.textView setFont:[self.curFont fontWithSize:--cFont]];
	}
}

#pragma mark - Private

- (void)createControls
{
	CGRect frame = CGRectMake(0, 0, kControlSize, kControlSize);
	
	self.deleteControl = [[UIImageView alloc] initWithFrame:frame];
	_deleteControl.image = getResource(@"Common/delete.png");
	_deleteControl.userInteractionEnabled = YES;
	[self addSubview:_deleteControl];
	
	frame = CGRectMake(self.frame.size.width-kControlSize, self.frame.size.height-kControlSize, kControlSize, kControlSize);
	
	self.resizingControl = [[UIImageView alloc] initWithFrame:frame];
	_resizingControl.image = getResource(@"Common/rotate.png");
	_resizingControl.userInteractionEnabled = YES;
	[self addSubview:_resizingControl];
	
	UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteControlTapAction:)];
	[self.deleteControl addGestureRecognizer:closeTap];
	
	UIPanGestureRecognizer *moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGestureAction:)];
	[self addGestureRecognizer:moveGesture];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
	[tapGesture setNumberOfTapsRequired:1];
	[tapGesture setNumberOfTouchesRequired:1];
	[self addGestureRecognizer:tapGesture];
	
	UIPanGestureRecognizer *panRotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateViewPanGesture:)];
	[self.resizingControl addGestureRecognizer:panRotateGesture];
	
	[moveGesture requireGestureRecognizerToFail:closeTap];
}

- (void)createTextView
{
	CGFloat leftMargin = kControlSize;
	CGFloat topMargin = kControlSize;
	CGFloat width = self.frame.size.width - leftMargin*2;
	CGFloat height = self.frame.size.height - topMargin*2;
	
	CGRect textViewFrame = CGRectMake(leftMargin, topMargin, width, height);
	
	self.textView = [[UITextView alloc] initWithFrame:textViewFrame];
	_textView.userInteractionEnabled = YES;
	_textView.scrollEnabled = NO;
	_textView.delegate = self;
	_textView.keyboardType  = UIKeyboardTypeASCIICapable;
	_textView.returnKeyType = UIReturnKeyDone;
	_textView.textAlignment = NSTextAlignmentCenter;
	_textView.backgroundColor = [UIColor whiteColor];
	_textView.textColor = [UIColor redColor];
	_textView.text = _defaultText;
	[_textView setAutocorrectionType:UITextAutocorrectionTypeNo];
	[self addSubview:_textView];
	[self sendSubviewToBack:_textView];
	_textView.textContainerInset = UIEdgeInsetsZero;
	
	CGFloat cFont = self.textView.font.pointSize;
	CGSize  tSize = [self textSizeWithFont:cFont text:nil];
	do
	{
		tSize = [self textSizeWithFont:++cFont text:nil];
	}
	while (![self isBeyondSize:tSize] && cFont < kMaxFontSize);
	cFont = (cFont < kMaxFontSize) ? cFont : self.minFontSize;
	[self.textView setFont:[self.curFont fontWithSize:--cFont]];
	
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
	tapGestureRecognizer.delegate = self;
	[tapGestureRecognizer setNumberOfTapsRequired:1];
	[tapGestureRecognizer setNumberOfTouchesRequired:1];
	[_textView addGestureRecognizer:tapGestureRecognizer];
}

- (void)layoutSubViewWithFrame:(CGRect)frame
{
	CGRect textViewFrame = frame;
	
	textViewFrame.size.width = self.bounds.size.width - kControlSize*2;
	textViewFrame.size.height = self.bounds.size.height - kControlSize*2;
	textViewFrame.origin.x = (self.bounds.size.width - textViewFrame.size.width)/2;
	textViewFrame.origin.y = (self.bounds.size.height - textViewFrame.size.height)/2;
	
	_textView.frame = textViewFrame;
	_deleteControl.frame = CGRectMake(0, 0, kControlSize, kControlSize);
	_resizingControl.frame = CGRectMake(self.bounds.size.width-kControlSize, self.bounds.size.height-kControlSize, kControlSize, kControlSize);
}

- (CGSize)textSizeWithFont:(CGFloat)font text:(NSString *)string
{
	NSString *text = string ? string : self.textView.text;
	
	CGFloat pO = self.textView.textContainer.lineFragmentPadding * 2;
	CGFloat cW = self.textView.frame.size.width - pO;
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[self.curFont fontWithSize:font], NSFontAttributeName, nil];
	CGSize tH = [text boundingRectWithSize:CGSizeMake(cW, MAXFLOAT)
								   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
								attributes:attributes
								   context:nil].size;
	return  tH;
}

- (BOOL)isBeyondSize:(CGSize)size
{
	CGFloat ost = _textView.textContainerInset.top + _textView.textContainerInset.bottom;
	return size.height + ost > self.textView.frame.size.height;
}

- (void)centerTextVertically
{
	CGSize  tH     = [self textSizeWithFont:self.textView.font.pointSize text:nil];
	CGFloat offset = (self.textView.frame.size.height - tH.height)/2.f;
	
	self.textView.textContainerInset = UIEdgeInsetsMake(offset, 0, offset, 0);
}

#pragma mark - Actions

- (void)deleteControlTapAction:(UITapGestureRecognizer *)tap
{
	[self removeFromSuperview];
	
	if (_delegate && [_delegate respondsToSelector:@selector(textEditorViewDidClose:)]) {
		[_delegate textEditorViewDidClose:self];
	}
}

- (void)tapGestureAction:(UITapGestureRecognizer *)recognizer
{
	if (_delegate && [_delegate respondsToSelector:@selector(textEditorViewDidTapped:)]) {
		[_delegate textEditorViewDidTapped:self];
	}
}

- (void)moveGestureAction:(UIPanGestureRecognizer * )recognizer
{
	_touchLocation = [recognizer locationInView:self.superview];
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		_beginningPoint = _touchLocation;
		_beginningCenter = self.center;
		[self setCenter:CGPointMake(_beginningCenter.x+(_touchLocation.x-_beginningPoint.x), _beginningCenter.y+(_touchLocation.y-_beginningPoint.y))];
		_beginBounds = self.bounds;
//        if([_delegate respondsToSelector:@selector(labelViewDidBeginEditing:)]) {
//            [_delegate labelViewDidBeginEditing:self];
//        }
	} else if (recognizer.state == UIGestureRecognizerStateChanged) {
		[self setCenter:CGPointMake(_beginningCenter.x+(_touchLocation.x-_beginningPoint.x), _beginningCenter.y+(_touchLocation.y-_beginningPoint.y))];
//        if([_delegate respondsToSelector:@selector(labelViewDidChangeEditing:)]) {
//            [_delegate labelViewDidChangeEditing:self];
//        }
	} else if (recognizer.state == UIGestureRecognizerStateEnded) {
		[self setCenter:CGPointMake(_beginningCenter.x+(_touchLocation.x-_beginningPoint.x), _beginningCenter.y+(_touchLocation.y-_beginningPoint.y))];
//        if([_delegate respondsToSelector:@selector(labelViewDidEndEditing:)]) {
//            [_delegate labelViewDidEndEditing:self];
//        }
	}
	
	_prevPoint = _touchLocation;
}

- (void)rotateViewPanGesture:(UIPanGestureRecognizer *)recognizer
{
	_touchLocation = [recognizer locationInView:self.superview];
	
	CGPoint center = CGRectGetCenter(self.frame);
	
	if ([recognizer state] == UIGestureRecognizerStateBegan) {
		//求出反正切角
		//NSLog(@"atan2:%@ ----- angle%@", @(atan2(touchLocation.y-center.y, touchLocation.x-center.x)), @(CGAffineTransformGetAngle(self.transform)));
		_deltaAngle = atan2(_touchLocation.y-center.y, _touchLocation.x-center.x)-CGAffineTransformGetAngle(self.transform);
		_initialBounds = self.bounds;
		_initialDistance = CGPointGetDistance(center, _touchLocation);
//        if([self.bubbleDelegate respondsToSelector:@selector(bubbleViewDidBeginEditing:)]) {
//            [self.bubbleDelegate bubbleViewDidBeginEditing:self];
//        }
	} else if ([recognizer state] == UIGestureRecognizerStateChanged) {
		
		NSLog(@"UIGestureRecognizerStateChanged");
		
		BOOL increase = NO;
		if (self.bounds.size.width < self.minSize.width || self.bounds.size.height < self.minSize.height)
		{
			self.bounds = CGRectMake(self.bounds.origin.x,
									 self.bounds.origin.y,
									 self.minSize.width,
									 self.minSize.height);
			self.resizingControl.frame =CGRectMake(self.bounds.size.width-kControlSize,self.bounds.size.height-kControlSize,
												   kControlSize,
												   kControlSize);
			self.deleteControl.frame = CGRectMake(0, 0,
												  kControlSize, kControlSize);
			_prevPoint = [recognizer locationInView:self];
		} else {
			CGPoint point = [recognizer locationInView:self];
			float wChange = 0.0, hChange = 0.0;
			wChange = (point.x - _prevPoint.x);
			hChange = (point.y - _prevPoint.y);
			
			NSLog(@"point:%@, wChange:%f, hChange:%f", NSStringFromCGPoint(point), wChange, hChange);
			
			if (ABS(wChange) > 20.0f || ABS(hChange) > 20.0f) {
				_prevPoint = [recognizer locationInView:self];
				return;
			}
			if (YES) {
				if (wChange < 0.0f && hChange < 0.0f) {
					float change = MIN(wChange, hChange);
					wChange = change;
					hChange = change;
				}
				if (wChange < 0.0f) {
					hChange = wChange;
				} else if (hChange < 0.0f) {
					wChange = hChange;
				} else {
					float change = MAX(wChange, hChange);
					wChange = change;
					hChange = change;
				}
			}
			increase = wChange > 0?YES:NO;
			self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
									 self.bounds.size.width + (wChange),
									 self.bounds.size.height + (hChange));
			
			[self layoutSubViewWithFrame:self.bounds];
			
			self.resizingControl.frame =CGRectMake(self.bounds.size.width-kControlSize,
												   self.bounds.size.height-kControlSize,
												   kControlSize, kControlSize);
			self.deleteControl.frame = CGRectMake(0, 0,
												  kControlSize, kControlSize);
			_prevPoint = [recognizer locationInView:self];
		}
		/* Rotation */
		float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
						  [recognizer locationInView:self.superview].x - self.center.x);
		float angleDiff = _deltaAngle - ang;
		self.transform = CGAffineTransformMakeRotation(-angleDiff);
		
		self.textView.textContainerInset = UIEdgeInsetsZero;
		
		if ([self.textView.text length])
		{
			CGFloat cFont = self.textView.font.pointSize;
			CGSize  tSize = [self textSizeWithFont:cFont text:nil];
			if (increase)
			{
				do
				{
					tSize = [self textSizeWithFont:++cFont text:nil];
				}
				while (![self isBeyondSize:tSize] && cFont < kMaxFontSize);
				cFont = (cFont < kMaxFontSize) ? cFont : self.minFontSize;
				[self.textView setFont:[self.curFont fontWithSize:--cFont]];
			}
			else
			{
				while ([self isBeyondSize:tSize] && cFont > 0)
				{
					tSize = [self textSizeWithFont:--cFont text:nil];
				}
				[self.textView setFont:[self.curFont fontWithSize:cFont]];
			}
		}
		[self centerTextVertically];
//        if([self.bubbleDelegate respondsToSelector:@selector(bubbleViewDidChangeEditing:)]) {
//            [self.bubbleDelegate bubbleViewDidChangeEditing:self];
//        }
	} else if ([recognizer state] == UIGestureRecognizerStateEnded) {
//        if([self.bubbleDelegate respondsToSelector:@selector(bubbleViewDidEndEditing:)]) {
//            [self.bubbleDelegate bubbleViewDidEndEditing:self];
//        }
	}
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if ([text isEqualToString:@"\n"])
	{
		[self endEditing:YES];
        if (_delegate && [_delegate respondsToSelector:@selector(textEditorViewDidEndEditing:)]) {
            [_delegate textEditorViewDidEndEditing:self];
        }
		return NO;
	}
	_isDeleting = (range.length >= 1 && text.length == 0);
	
	if (textView.font.pointSize <= self.minFontSize && !_isDeleting) return NO;
	
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	NSString *calcStr = textView.text;
	
	if (_delegate && [_delegate respondsToSelector:@selector(textEditorViewTextDidChanged:)]) {
		[_delegate textEditorViewTextDidChanged:self];
	}
	
	if (![textView.text length]) [self.textView setText:_defaultText];
	CGFloat cFont = self.textView.font.pointSize;
	CGSize  tSize = [self textSizeWithFont:cFont text:nil];
	
	self.textView.textContainerInset = UIEdgeInsetsZero;
	
	if (_isDeleting)
	{
		do
		{
			tSize = [self textSizeWithFont:++cFont text:nil];
		}
		while (![self isBeyondSize:tSize] && cFont < kMaxFontSize);
		
		cFont = (cFont < kMaxFontSize) ? cFont : self.minFontSize;
		[self.textView setFont:[self.curFont fontWithSize:--cFont]];
	}
	else
	{
		NSLog(@"---%d",[self isBeyondSize:tSize]);
		
		while ([self isBeyondSize:tSize] && cFont > 0)
		{
			tSize = [self textSizeWithFont:--cFont text:nil];
		}
		
		[self.textView setFont:[self.curFont fontWithSize:cFont]];
	}
	[self centerTextVertically];
	[self.textView setText:calcStr];
}

#pragma mark - 

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

@end
