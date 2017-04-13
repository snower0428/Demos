//
//  ViewController.m
//  FontsDemo
//
//  Created by leihui on 16/12/28.
//  Copyright © 2016年 ND WebSoft Inc. All rights reserved.
//

#import "ViewController.h"
#import "FontsViewController.h"
#import "PHTextEditorDefines.h"
#import "PHTextEditorView.h"
#import "PHTextEditorToolbar.h"
#import "PHTextEditorElementContainerView.h"
#import "PHTextEditorFontView.h"
#import "PHTextEditorFontColorView.h"

@interface ViewController () <  PHTextEditorViewDelegate, PHTextEditorToolbarDelegate, PHTextEditorElementContainerViewDelegate,
								UIGestureRecognizerDelegate >

@property (nonatomic, strong) PHTextEditorView *currentTextEditorView;
@property (nonatomic, strong) PHTextEditorToolbar *toolBar;
@property (nonatomic, strong) PHTextEditorElementContainerView *elementContainer;
@property (nonatomic, strong) NSMutableArray *arrayEditor;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.title = @"Fonts";
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.arrayEditor = [NSMutableArray array];
	
	[self createNavagationItem];
	[self createViews];
	[self addGestureRecognizer];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)createViews
{
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	imageView.image = getResource(@"Common/1.jpg");
	[self.view addSubview:imageView];
	
	CGFloat width = 50.f;
	CGFloat height = 50.f;
	CGFloat leftMargin = (SCREEN_WIDTH-width)/2;
	CGFloat topMargin = SCREEN_HEIGHT-100.f;
	
	UIButton *btnAddText = [UIButton buttonWithType:UIButtonTypeCustom];
	btnAddText.backgroundColor = [UIColor orangeColor];
	btnAddText.frame = CGRectMake(leftMargin, topMargin, width, height);
	[btnAddText setTitle:@"+T" forState:UIControlStateNormal];
	[btnAddText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	btnAddText.layer.cornerRadius = 5.f;
	[self.view addSubview:btnAddText];
	[btnAddText addTarget:self action:@selector(addTextAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createNavagationItem
{
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(leftAction:)];
	self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)createTextEditorView
{
	CGFloat width = 150.f*iPhoneWidthScaleFactor;
	CGFloat height = 80.f*iPhoneWidthScaleFactor;
	CGFloat leftMargin = (SCREEN_WIDTH-width)/2;
	CGFloat topMargin = 100.f;
	CGRect frame = CGRectMake(leftMargin, topMargin, width, height);
	
	PHTextEditorView *textEditorView = [[PHTextEditorView alloc] initWithFrame:frame];
	textEditorView.backgroundColor = [UIColor orangeColor];
	textEditorView.delegate = self;
	[self.view addSubview:textEditorView];
	
	[_arrayEditor addObject:textEditorView];
	
	self.currentTextEditorView = textEditorView;
}

- (void)createTextEditorToolbar
{
	CGRect frame = CGRectMake(0, self.view.frame.size.height-kToolbarHeight, self.view.frame.size.width, kToolbarHeight);
	
	if (self.toolBar == nil) {
		self.toolBar = [[PHTextEditorToolbar alloc] initWithFrame:frame];
		_toolBar.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.f];
		_toolBar.delegate = self;
		[self.view addSubview:_toolBar];
		_toolBar.alpha = 0.f;
	}
}

- (void)createElementContainer
{
	CGFloat height = kElementContainerViewHeight;
	CGRect elementFrame = CGRectMake(0, self.view.frame.size.height-height, self.view.frame.size.width, height);
	
	if (self.elementContainer == nil) {
		self.elementContainer = [[PHTextEditorElementContainerView alloc] initWithFrame:elementFrame];
		_elementContainer.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
		_elementContainer.delegate = self;
		[self.view addSubview:_elementContainer];
		_elementContainer.hidden = YES;
	}
}

- (void)resetToolBar:(NSDictionary *)userInfo
{
	double duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	CGRect toolBarFrame = _toolBar.frame;
	toolBarFrame.origin.y = keyboardFrame.origin.y - toolBarFrame.size.height;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:duration];
	_toolBar.frame = toolBarFrame;
	[UIView commitAnimations];
	
	[self.view bringSubviewToFront:_toolBar];
}

- (void)addGestureRecognizer
{
	// Add tap gesture
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
	tapGestureRecognizer.delegate = self;
	[tapGestureRecognizer setNumberOfTapsRequired:1];
	[tapGestureRecognizer setNumberOfTouchesRequired:1];
	[self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)showView:(UIView *)view
{
	if (view) {
		__block ViewController *weakSelf = self;
		[UIView animateWithDuration:0.3
							  delay:0.0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^(void){
							 CGRect viewFrame = CGRectMake(0, self.view.frame.size.height - 216, self.view.frame.size.width, 216);
							 view.frame = viewFrame;
							 
							 // Set tool bar frame
							 CGRect toolBarFrame = weakSelf.toolBar.frame;
							 toolBarFrame.origin.y = viewFrame.origin.y - toolBarFrame.size.height;
							 weakSelf.toolBar.frame = toolBarFrame;
						 }completion:^(BOOL finished){
							 
						 }];
	}
}

- (void)hideView:(UIView *)view
{
	if (view) {
		__block ViewController *weakSelf = self;
		[UIView animateWithDuration:0.3
							  delay:0.0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^(void){
							 CGRect viewFrame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 216);
							 view.frame = viewFrame;
							 
							 // Set tool bar frame
							 CGRect toolBarFrame = weakSelf.toolBar.frame;
							 toolBarFrame.origin.y = viewFrame.origin.y - toolBarFrame.size.height;
							 weakSelf.toolBar.frame = toolBarFrame;
						 }completion:^(BOOL finished){
							 view.hidden = YES;
						 }];
	}
}

- (void)showElementContainer:(PHTextEditorToolBarAction)action
{
	MLOG(@"============================== showElementContainer ==============================");
	
	if (_elementContainer.hidden) {
		_elementContainer.hidden = NO;
		[self.view bringSubviewToFront:_elementContainer];
	}
	
	[self showView:_elementContainer];
	[_elementContainer frontViewWithAction:action];
}

#pragma mark - Actions

- (void)addTextAction:(id)sender
{
	[self createTextEditorView];
	[self createTextEditorToolbar];
	[self createElementContainer];
	
	_toolBar.alpha = 1.f;
	[_currentTextEditorView.textView becomeFirstResponder];
}

- (void)leftAction:(id)sender
{
	FontsViewController *ctrl = [[FontsViewController alloc] init];
	[self.navigationController pushViewController:ctrl animated:YES];
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
	for (PHTextEditorView *textEditorView in _arrayEditor) {
		if (textEditorView.textView.isFirstResponder) {
			[textEditorView.textView resignFirstResponder];
			break;
		}
	}
	[self hideView:_elementContainer];
}

#pragma mark - PHTextEditorViewDelegate

- (void)textEditorViewDidTapped:(PHTextEditorView *)textEditorView
{
	self.currentTextEditorView = textEditorView;
	
	[self.view bringSubviewToFront:_currentTextEditorView];
}

- (void)textEditorViewDidClose:(PHTextEditorView *)textEditorView
{
	if ([_arrayEditor containsObject:textEditorView]) {
		[_arrayEditor removeObject:textEditorView];
	}
	if ([_arrayEditor count] == 0) {
		_toolBar.alpha = 0.f;
	}
	[self hideView:_elementContainer];
}

- (void)textEditorViewTextDidChanged:(PHTextEditorView *)textEditorView
{
	NSString *text = textEditorView.textView.text;
	BOOL isEmptyString = [NSString isEmptyString:text];
	if (isEmptyString) {
		[_toolBar enabledToolbar:NO];
	}
	else {
		[_toolBar enabledToolbar:YES];
	}
}

#pragma mark - PHTextEditorToolbarDelegate

- (void)didSelectedKeyboard
{
	if (_currentTextEditorView) {
		[_currentTextEditorView.textView becomeFirstResponder];
	}
}

- (void)didSelectedFont
{
	if (_currentTextEditorView.textView.isFirstResponder) {
		[_currentTextEditorView.textView resignFirstResponder];
	}
	
	[self showElementContainer:PHTextEditorToolBarActionFont];
}

- (void)didSelectedFontColor
{
	if (_currentTextEditorView.textView.isFirstResponder) {
		[_currentTextEditorView.textView resignFirstResponder];
	}
	
	[self showElementContainer:PHTextEditorToolBarActionFontColor];
}

#pragma mark - PHTextEditorElementContainerViewDelegate

- (void)didSelectedFont:(NSString *)fontName
{
	if (_currentTextEditorView) {
		CGFloat pointSize = _currentTextEditorView.textView.font.pointSize;
		_currentTextEditorView.curFont = [UIFont fontWithName:fontName size:pointSize];
	}
}

- (void)didSelectedColor:(UIColor *)color
{
	if (_currentTextEditorView) {
		_currentTextEditorView.textView.textColor = color;
	}
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	return ([[touch.view class] isSubclassOfClass:[UIButton class]] ||
			[[touch.view class] isSubclassOfClass:[PHTextEditorView class]] ||
			[[touch.view.superview class] isSubclassOfClass:[UITableViewCell class]]) ? NO : YES;
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
	[self resetToolBar:notification.userInfo];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
	[self resetToolBar:notification.userInfo];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification
{
	[self resetToolBar:notification.userInfo];
}

#pragma mark - dealloc

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
