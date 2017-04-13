//
//  PHTextEditorFontView.h
//  InstaSave
//
//  Created by leihui on 16/12/28.
//  Copyright © 2016年 ~. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PHTextEditorFontViewDelegate;

@interface PHTextEditorFontView : UIView

@property (nonatomic, weak) id <PHTextEditorFontViewDelegate> delegate;

@end

#pragma mark - PHTextEditorFontViewDelegate

@protocol PHTextEditorFontViewDelegate <NSObject>

@optional

- (void)didSelectedFont:(NSString *)fontName;

@end
