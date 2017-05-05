//
//  CombineImageView.m
//  ImagesCombine
//
//  Created by ZZF on 13-9-13.
//  Copyright (c) 2013年 ZZF. All rights reserved.
//

#import "CombineImageView.h"

@interface CombineImageView()

- (void)showOverlayWithFrame:(CGRect)changeframe;

@end

@implementation CombineImageView

@synthesize photoImage;

- (void)dealloc
{
    [photoImage release];
    photoImage = nil;
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        photoImage.userInteractionEnabled = YES;
        [self addSubview:photoImage];
        
        //        UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)] autorelease];
        //        [rotationRecognizer setDelegate:self];
        //        [photoImage addGestureRecognizer:rotationRecognizer];
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    photoImage.transform = CGAffineTransformIdentity;
    [photoImage setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

-(void)resetTransform{
    photoImage.transform = CGAffineTransformIdentity;
}

-(void)setImage:(UIImage *)image{
    photoImage.image = image;
}

-(UIImage *)getImage{
    return photoImage.image;
}

// 旋转
-(void)rotate:(id)sender {
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    CGAffineTransform currentTransform = photoImage.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [photoImage setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    NSLog(@"x=%f y=%f w=%f h=%f",photoImage.frame.origin.x,photoImage.frame.origin.y,photoImage.frame.size.width,photoImage.frame.size.height);
    //    [self showOverlayWithFrame:photoImage.frame];
}

- (void)showOverlayWithFrame:(CGRect)changeframe
{
    self.bounds = changeframe;
}

@end
