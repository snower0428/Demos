//
//  PHImageScrollView.m
//  ImagesCombine
//
//  Created by ZZF on 13-8-28.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import "PHImageScrollView.h"

#define VIEW_TAG                1000
#define IMAGE_TAG               2000
#define BUTTON_TAG              5000


#define DEFAULT_SCROLL_ITEM     10
#define SCROLL_ITEM_WIDTH       90
#define SCROLL_ITEM_HEIGHT      90
#define SCROLL_ITEM_INTERVAL    10

static const CGFloat kOffset = 5.f;
static const CGFloat kWidth = 30.f;
static const CGFloat kLeftMargin = 10.f;

@interface PHImageScrollView()
{
    BOOL    _isRemoving;
    NSInteger   _index;
}

- (void)addViews;

@end

@implementation PHImageScrollView

@synthesize delegate = _delegate;
@synthesize listItems = _listItems;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = NO;
        [self addSubview:_scrollView];
        
        self.listItems = items;
        
//        [self addViews];
    }
    return self;
}

- (void)addViews
{
    int space = 0;
    for (int i = 0; i < DEFAULT_SCROLL_ITEM; i++)
    {
        CGRect viewFrame = CGRectMake(kLeftMargin + i*SCROLL_ITEM_WIDTH+space, (self.frame.size.height-SCROLL_ITEM_HEIGHT)/2, SCROLL_ITEM_WIDTH, SCROLL_ITEM_HEIGHT);
        UIView *view = [[UIView alloc] initWithFrame:viewFrame];
        view.backgroundColor = [UIColor redColor];
        view.hidden = YES;
        view.tag = VIEW_TAG + i;
        
        //Icon
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCROLL_ITEM_WIDTH, SCROLL_ITEM_HEIGHT)];
        icon.userInteractionEnabled = YES;
        icon.tag = IMAGE_TAG + i;
        [view addSubview:icon];
        [icon release];
        
        //删除按钮
        UIImage *removeimage = getResource(@"ImageCombine/closeBtn.png");
        UIButton *removebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        removebtn.tag = BUTTON_TAG+i;
		removebtn.frame = CGRectMake(-kOffset, -kOffset, kWidth, kWidth);
        [removebtn setBackgroundImage:removeimage forState:UIControlStateNormal];
		[removebtn addTarget:self action:@selector(removeImageAction:) forControlEvents:UIControlEventTouchUpInside];
		[icon addSubview:removebtn];
        
        [_scrollView addSubview:view];
        [view release];
        
        space += SCROLL_ITEM_INTERVAL;
    }
}

- (void)updateItems:(NSArray *)items
{
    self.listItems = items;
    
#if 1
    
    [[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < [items count]; i++) {
        
        CGRect viewFrame = CGRectMake(kLeftMargin + i*SCROLL_ITEM_WIDTH + i*SCROLL_ITEM_INTERVAL, (self.frame.size.height-SCROLL_ITEM_HEIGHT)/2,
                                      SCROLL_ITEM_WIDTH, SCROLL_ITEM_HEIGHT);
        UIView *view = [[[UIView alloc] initWithFrame:viewFrame] autorelease];
        view.tag = VIEW_TAG+i;
        [_scrollView addSubview:view];
        
        UIImage *image = [items objectAtIndex:i];
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:view.bounds] autorelease];
        imageView.image = image;
        [view addSubview:imageView];
        
        //删除按钮
        UIImage *removeimage = getResource(@"ImageCombine/closeBtn.png");
        UIButton *removebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        removebtn.tag = BUTTON_TAG+i;
        removebtn.frame = CGRectMake(-kOffset, -kOffset, kWidth, kWidth);
//        removebtn.backgroundColor = [UIColor blueColor];
        [removebtn setBackgroundImage:removeimage forState:UIControlStateNormal];
        [removebtn addTarget:self action:@selector(removeImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:removebtn];
    }
    
    NSInteger itemCount = [items count];
    _scrollView.contentSize = CGSizeMake(kLeftMargin + SCROLL_ITEM_WIDTH*itemCount+SCROLL_ITEM_INTERVAL*itemCount, _scrollView.frame.size.height);
    
    if (_isRemoving) {
        _isRemoving = NO;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.15];
        NSInteger itemCount = [items count];
        _scrollView.contentSize = CGSizeMake(kLeftMargin + SCROLL_ITEM_WIDTH*itemCount+SCROLL_ITEM_INTERVAL*itemCount, _scrollView.frame.size.height);
        [UIView commitAnimations];
    }
    else {
        if (itemCount > 3) {
            NSInteger offsetCount = itemCount - 3;
            [_scrollView setContentOffset:CGPointMake(SCROLL_ITEM_WIDTH*offsetCount+SCROLL_ITEM_INTERVAL*(offsetCount-1), 0) animated:YES];
        }
    }
    
#else
    
    NSArray *views = [_scrollView subviews];
    
    //隐藏不用到的view
    for (int i = [items count]; i < DEFAULT_SCROLL_ITEM; i++) {
        if (i < [views count]) {
            UIView *view = [views objectAtIndex:i];
            view.hidden = YES;
        }
    }
    
    for (int i = 0; i < [items count]; i++) {
        
        if (i < [views count]) {
            UIView *view = [views objectAtIndex:i];
            view.hidden = NO;
            //Icon
            UIImageView *icon = (UIImageView *)[self viewWithTag:IMAGE_TAG+i];
            if (icon) {
                UIImage *image = [items objectAtIndex:i];
                icon.image = image;
            }
        }
    }
    
    int itemCount = [items count];
    
    _scrollView.contentSize = CGSizeMake(kLeftMargin + SCROLL_ITEM_WIDTH*itemCount+SCROLL_ITEM_INTERVAL*itemCount, _scrollView.frame.size.height);
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.15];
    if (_isRemoving) {
        _isRemoving = NO;
//        [_scrollView scrollRectToVisible:CGRectMake((_index-2)*SCROLL_ITEM_WIDTH, 0, SCROLL_ITEM_WIDTH, SCROLL_ITEM_HEIGHT) animated:YES];
    }
    else {
        if (itemCount > 3) {
            int offsetCount = itemCount - 3;
//            _scrollView.contentOffset = CGPointMake(SCROLL_ITEM_WIDTH*offsetCount+SCROLL_ITEM_INTERVAL*(offsetCount-1), 0);
            [_scrollView setContentOffset:CGPointMake(SCROLL_ITEM_WIDTH*offsetCount+SCROLL_ITEM_INTERVAL*(offsetCount-1), 0) animated:YES];
        }
    }
//    [UIView commitAnimations];
    
#endif
}

- (void)removeImageAction:(id)sender
{
    NSInteger tag = [sender tag]-BUTTON_TAG;
    if (_delegate && [_delegate respondsToSelector:@selector(didRemoveItemWithIndex:)]){
        _isRemoving = YES;
        _index = tag;
        [_delegate didRemoveItemWithIndex:(int)tag];
    }
    NSLog(@"remove");
}

#pragma mark - dealloc

- (void)dealloc
{
    [_scrollView release];
    self.delegate = nil;
    self.listItems = nil;
    
    [super dealloc];
}

@end

