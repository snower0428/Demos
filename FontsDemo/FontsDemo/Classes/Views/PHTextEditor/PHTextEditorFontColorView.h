//
//  PHTextEditorFontColorView.h
//  InstaSave
//
//  Created by leihui on 16/12/29.
//  Copyright © 2016年 ~. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PHTextEditorFontColorViewDelegate;

@interface PHTextEditorFontColorView : UIView

@property (nonatomic, weak) id <PHTextEditorFontColorViewDelegate> delegate;

@end

#pragma mark - PHTextEditorFontColorViewDelegate

@protocol PHTextEditorFontColorViewDelegate <NSObject>

@optional

- (void)didSelectedColor:(UIColor *)color;

@end
