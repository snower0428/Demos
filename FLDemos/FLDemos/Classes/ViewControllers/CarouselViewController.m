//
//  CarouselViewController.m
//  FLDemos
//
//  Created by leihui on 2020/2/7.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "CarouselViewController.h"
#import "iCarousel.h"

@interface CarouselViewController () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation CarouselViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Init
        self.items = @[].mutableCopy;
        for (int i = 0; i < 10; i++) {
            [_items addObject:@(i)];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self wr_setNavBarBackgroundAlpha:0.f];
    
    self.carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
    _carousel.type = iCarouselTypeCustom;
    _carousel.dataSource = self;
    _carousel.delegate = self;
    _carousel.bounces = NO;
    _carousel.pagingEnabled = YES;
    [self.view addSubview:_carousel];
}

- (void)dealloc {
    _carousel.dataSource = nil;
    _carousel.delegate = nil;
}

#pragma mark - iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil) {
        CGRect frame = CGRectInset(self.view.bounds, 50, 50);
        view = [[UIImageView alloc] initWithFrame:frame];
        view.backgroundColor = kRandomColor;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    } else {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [_items[index] stringValue];
    
    return view;
}

#pragma mark - iCarouselDelegate

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    NSLog(@"offset:%@", @(offset));
//    static CGFloat max_sacle = 1.0f;
//    static CGFloat min_scale = 0.6f;
//    if (offset <= 1 && offset >= -1) {
//        float tempScale = offset < 0 ? 1+offset : 1-offset;
//        float slope = (max_sacle - min_scale) / 1;
//        CGFloat scale = min_scale + slope*tempScale;
//        transform = CATransform3DScale(transform, scale, scale, 1);
//    }else{
//        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
//    }
//    return CATransform3DTranslate(transform, offset * self.carousel.itemWidth * 1.4, 0.0, 0.0);
    
    transform = CATransform3DTranslate(transform, offset * (self.carousel.itemWidth), 0, 0);
    CGFloat scalex = MAX(0, (1-(6.0/self.carousel.itemWidth * fabs(offset))));
    CGFloat scaley = MAX(0, (1-(12.0/(130.0) * fabs(offset))));
    return CATransform3DScale(transform, scalex, scaley, 1);
}

//- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
//    switch (option) {
//        case iCarouselOptionSpacing:
//            return value * 1.25f;
//        default:
//            break;
//    }
//    return value;
//}

@end
