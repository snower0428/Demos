//
//  ImageZoomView.m
//  ImagesCombine
//
//  Created by ZZF on 13-8-30.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import "ImageZoomView.h"
#import <QuartzCore/QuartzCore.h>

@interface ImageZoomView (ImageZoomViewMethods)
- (void)loadSubviewsWithFrame:(CGRect)frame;
- (BOOL)isZoomed;
//比较图片的长宽和视图的长宽，从而可以适当的缩放图片的大小
-(CGSize)getImageSizeWithOriginal:(CGSize)imageSize;
@end

@implementation ImageZoomView

@synthesize index = _index;
@synthesize touchDelegate = _touchDelegate;

- (void)dealloc
{
    [_imageView release];
    _imageView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:self];
        //        [self setMaximumZoomScale:2.0];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self loadSubviewsWithFrame:frame];
        
        self.scrollEnabled = NO;
        self.userInteractionEnabled = YES;
        
        //        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        //        [doubleTap setNumberOfTapsRequired:2];
        //        [self addGestureRecognizer:doubleTap];
        //        [doubleTap release];
    }
    return self;
}

- (void)loadSubviewsWithFrame:(CGRect)frame
{
    UIView * backView = [[UIView alloc] initWithFrame:frame];
    backView.userInteractionEnabled = NO;
    [self addSubview:backView];
    [backView release];
    
    _imageView = [[CombineImageView alloc] initWithFrame:frame];
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
}

-(void)changeViewFrame:(CGRect)frame{
    [self turnOffZoom];
    self.frame = frame;
    [_imageView resetTransform];
    CGSize  size = [self getImageSizeWithOriginal:_imageView.frame.size];
    _imageView.frame = CGRectMake(0, 0, size.width, size.height);
    //    _imageView.center = self.center;
    self.contentSize = size;
    [self setMaxMinZoomScalesForCurrentBounds];
}

- (void)setImage:(UIImage *)newImage
{
    [self turnOffZoom];
    
    CGSize imageSize = newImage.size;
    CGSize  size = [self getImageSizeWithOriginal:imageSize];
    
    _imageView.hidden = NO;
    _imageView.frame = CGRectMake(0, 0, size.width, size.height);
    self.contentSize = size;
    self.contentOffset = CGPointZero;
    _imageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    [_imageView setImage:newImage];
    
    [self setMaxMinZoomScalesForCurrentBounds];
	imagescale = 2;
    //	self.zoomScale = imagescale;
    
}


- (void)setImageUrl:(NSURL *)url{
    
    //    [_imageView setImageWithURL:url placeholderImage:getResource(@"CommImage/loadingImage1024.png")];
}

-(UIImage *)getImage{
    return [_imageView getImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self isZoomed] == NO && CGRectEqualToRect([self bounds], [_imageView frame]) == NO) {
        _imageView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        //        _imageView.center = self.center;
    }
}

//比较图片的长宽和视图的长宽，从而可以适当的缩放图片的大小
-(CGSize)getImageSizeWithOriginal:(CGSize)imageSize{
    
    CGSize viewSize = self.bounds.size;
    CGSize  size = CGSizeMake(210, 210*imageSize.height/imageSize.width);
    //比较图片的长宽和视图的长宽，从而可以适当的缩放图片的大小
    BOOL isbool = (imageSize.width/imageSize.height) > (viewSize.width/viewSize.height);
    if (isbool) {
        size.height = CGRectGetHeight(self.frame)+10;
        size.width = size.height*imageSize.width/imageSize.height;
        
    }else{
        size.width = CGRectGetWidth(self.frame)+10;
        size.height = size.width*imageSize.height/imageSize.width;
    }
    return size;
}

- (BOOL)isZoomed
{
    return !([self zoomScale] == [self minimumZoomScale]);
}


- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTap:) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    CGPoint centerPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    centerPoint.x = centerPoint.x / self.zoomScale;
    centerPoint.y = centerPoint.y / self.zoomScale - _imageView.frame.origin.y;
    if (self.zoomScale > self.minimumZoomScale) {
        CGRect zoomRect = [self zoomRectForScale:self.minimumZoomScale withCenter:centerPoint];
        [self zoomToRect:zoomRect animated:YES];
    } else {
        NSLog(@"center x:%.2f, y:%.2f",centerPoint.x, centerPoint.y);
        CGRect zoomRect = [self zoomRectForScale:imagescale withCenter:centerPoint];
        [self zoomToRect:zoomRect animated:YES];
        NSLog(@"rect origin x:%.2f, y%.2f",zoomRect.origin.x,zoomRect.origin.y);
        NSLog(@"rect width:%.2f, height:%.2f",zoomRect.size.width,zoomRect.size.height);
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)zoomToLocation:(CGPoint)location
{
    float newScale;
    CGRect zoomRect;
    if ([self isZoomed]) {
        zoomRect = [self bounds];
    } else {
        newScale = [self maximumZoomScale];
        zoomRect = [self zoomRectForScale:newScale withCenter:location];
    }
    
    [self zoomToRect:zoomRect animated:YES];
}

- (void)turnOffZoom
{
    if ([self isZoomed]) {
        [self zoomToLocation:CGPointZero];
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if (isTouchMove == YES) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    UITouch *touch = [touches anyObject];
    //        //printf("point = %lf,%lf\n", pt.x, pt.y);
    //
    //    if ([touch view] == self) {
    //        if ([touch tapCount] == 2) {
    //        }
    //    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSUInteger touchCount = [[touches allObjects] count];
    if (touchCount == 1) {
        UITouch *touch = [touches anyObject];
        if (touch.view == _imageView.photoImage)
        {
            
            NSLog(@"x,y = %lf,%lf w,h = %lf,%lf", _imageView.frame.origin.x, _imageView.frame.origin.y,_imageView.frame.size.width, _imageView.frame.size.height);
            NSLog(@"contentOffset = %lf,%lf", self.contentOffset.x, self.contentOffset.y);
            CGPoint prevPoint = [touch previousLocationInView:self];
            CGPoint curPoint = [touch locationInView:self];
            
            //缩略图 判断
            CGSize frameSize = self.frame.size;
            CGPoint  superPoint= [touch locationInView:[self superview]];
            //            NSLog(@"curPoint = %lf,%lf", curPoint.x, curPoint.y);
            //            NSLog(@"superPoint = %lf,%lf", superPoint.x, superPoint.y);
            if (isTouchMove||(curPoint.x < self.contentOffset.x || curPoint.x > frameSize.width+self.contentOffset.x || curPoint.y < self.contentOffset.y || curPoint.y > frameSize.height+self.contentOffset.y))
            {
                if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(imageTouchedMoved:point:)])
                {
                    [_touchDelegate imageTouchedMoved:self point:superPoint];
                }
                isTouchMove = YES;
                _imageView.hidden = YES;
            }
            
            //移动操作
            CGPoint centerPoint  = _imageView.center;
            centerPoint.x = centerPoint.x + curPoint.x - prevPoint.x;
            centerPoint.y = centerPoint.y + curPoint.y - prevPoint.y;
            [_imageView setCenter:centerPoint];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == _imageView.photoImage) {
        CGPoint centerPoint  = _imageView.center;
        CGSize  imageSize = _imageView.frame.size;
        CGPoint imagePoint  = _imageView.frame.origin;
        
        NSLog(@"x,y = %lf,%lf w,h = %lf,%lf", _imageView.frame.origin.x, _imageView.frame.origin.y,_imageView.frame.size.width, _imageView.frame.size.height);
        NSLog(@"contentOffset = %lf,%lf", self.contentOffset.x, self.contentOffset.y);
        
        //边界回弹效果
        //left
        if (imagePoint.x>self.contentOffset.x) {
            centerPoint.x = self.contentOffset.x + imageSize.width/2.0;
        }
        
        //right
        if ((imagePoint.x+_imageView.frame.size.width-self.contentOffset.x) < self.frame.size.width) {
            centerPoint.x = self.frame.size.width-_imageView.frame.size.width+ self.contentOffset.x+ imageSize.width/2.0;
        }
        
        //up
        if (imagePoint.y>self.contentOffset.y) {
            centerPoint.y = self.contentOffset.y + imageSize.height/2.0;
        }
        
        //down
        if ((imagePoint.y+_imageView.frame.size.height-self.contentOffset.y) < self.frame.size.height) {
            centerPoint.y = self.frame.size.height-_imageView.frame.size.height+ self.contentOffset.y+ imageSize.height/2.0;
        }
        
        [UIView animateWithDuration:0.1f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _imageView.center = centerPoint;
                         }
                         completion:nil];
        
        //还原交换状态
        if (isTouchMove == YES) {
            CGPoint  superPoint= [touch locationInView:[self superview]];
            if (_touchDelegate && [_touchDelegate respondsToSelector:@selector(imageTouchedEnded:point:)]) {
                [_touchDelegate imageTouchedEnded:self point:superPoint];
            }
            _imageView.hidden = NO;
            isTouchMove = NO;
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *viewToZoom = _imageView;
    return viewToZoom;
}


#pragma mark -
#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image

- (void)setMaxMinZoomScalesForCurrentBounds
{
    CGFloat xScale = SCREEN_WIDTH / self.frame.size.width;
	CGFloat yScale = SCREEN_HEIGHT / self.frame.size.height;
    
    
    CGFloat maxScale = MAX(xScale, yScale)*1.2;
    CGFloat minScale = 1.0;
    
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

@end

