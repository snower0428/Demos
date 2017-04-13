//
//  PHTextEditorElementContainerView.h
//  InstaSave
//
//  Created by leihui on 16/12/28.
//  Copyright © 2016年 ~. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHTextEditorDefines.h"

@protocol PHTextEditorElementContainerViewDelegate;

@interface PHTextEditorElementContainerView : UIView

@property (nonatomic, weak) id <PHTextEditorElementContainerViewDelegate> delegate;

- (void)frontViewWithAction:(PHTextEditorToolBarAction)action;

@end

#pragma mark - PHTextEditorElementContainerViewDelegate

@protocol PHTextEditorElementContainerViewDelegate <NSObject>

@optional

- (void)didSelectedFont:(NSString *)fontName;
- (void)didSelectedColor:(UIColor *)color;

@end
