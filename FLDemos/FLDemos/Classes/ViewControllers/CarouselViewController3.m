//
//  CarouselViewController3.m
//  FLDemos
//
//  Created by leihui on 2020/2/20.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "CarouselViewController3.h"
#import "iCarousel.h"

#define TAG_COVER_VIEW 9999

@interface CarouselViewController3 () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, assign) CGSize cardSize;

@end

@implementation CarouselViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 一行代码搞定导航栏透明度
    [self wr_setNavBarBackgroundAlpha:0.f];
    // 一行代码搞定导航栏两边按钮颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    // 一行代码搞定状态栏是 default 还是 lightContent
    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    
    CGFloat cardWidth = [UIScreen mainScreen].bounds.size.width * 0.5f;
    self.cardSize = CGSizeMake(cardWidth, [UIScreen mainScreen].bounds.size.width);
    self.view.backgroundColor = [UIColor blackColor];
    
    self.carousel = [[iCarousel alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeCustom;
    _carousel.bounceDistance = 0.2f;
    _carousel.vertical = YES;
    [self.view addSubview:_carousel];
}

#pragma mark - iCarouselDataSource <NSObject>

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    
    return 15;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    
    UIView *cardView = view;
    if (!cardView) {
        cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cardSize.width, self.cardSize.height)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cardView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor whiteColor];
        [cardView addSubview:imageView];
        
        cardView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0f].CGPath;
        cardView.layer.shadowRadius = 3.0f;
        cardView.layer.shadowColor = [UIColor blackColor].CGColor;
        cardView.layer.shadowOpacity = 0.5f;
        cardView.layer.shadowOffset = CGSizeMake(0, 0);
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = imageView.bounds;
        layer.path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:5.0f].CGPath;
        imageView.layer.mask = layer;
        
        UILabel *label = [[UILabel alloc] initWithFrame:cardView.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.text = [@(index) stringValue];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:200];
        [cardView addSubview:label];
        
        UIView *cover = [[UIView alloc] initWithFrame:cardView.bounds];
        cover.backgroundColor = [UIColor blackColor];
        cover.layer.opacity = 0.3f;
        cover.tag = TAG_COVER_VIEW;
        [cardView addSubview:cover];
    }
    
    return cardView;
}

#pragma mark - iCarouselDelegate <NSObject>

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    
    CGFloat scale = [self scaleByOffset:offset];
    CGFloat translation = [self translationByOffset:offset];
    transform = CATransform3DRotate(transform, M_PI/2, 0, 0, 1);
    transform = CATransform3DTranslate(transform, translation*self.cardSize.width, 0, offset);
    transform = CATransform3DScale(transform, scale, scale, 1.0f);
    return transform;
}

- (void)carouselDidScroll:(iCarousel *)carousel {
    
    for (UIView *view in carousel.visibleItemViews) {
        CGFloat offset = [carousel offsetForItemAtIndex:[carousel indexOfItemView:view]];
        UIView *cover = [view viewWithTag:TAG_COVER_VIEW];
        if (fabs(offset)>1.0f) {
            offset = 1.0f;
        }
        cover.layer.opacity = fabs(offset*0.3f);
    }
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    
    return self.cardSize.width;
}

- (CGFloat) carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionVisibleItems:
            return 15;
            break;
        case iCarouselOptionWrap:
            return YES;
            break;
        default:
            break;
    }
    return value;
}

#pragma mark - Private

// 形变是线性的就ok了
- (CGFloat)scaleByOffset:(CGFloat)offset {
    
    return 1.0f;
}

// 位移通过得到的公式来计算
- (CGFloat)translationByOffset:(CGFloat)offset {
    
    if (offset>=0 && offset<1) {
        return offset-0.5f;
    } else if (offset<0) {
        return offset*0.5f-0.5f;
    }
    return 0.5f+(offset-1.f)*5.0f/12.0f;
}

@end
