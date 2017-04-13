//
//  PHTextEditorToolbar.h
//  InstaSave
//
//  Created by leihui on 16/12/28.
//  Copyright © 2016年 ~. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PHTextEditorToolbarDelegate;

@interface PHTextEditorToolbar : UIView

@property (nonatomic, weak) id <PHTextEditorToolbarDelegate> delegate;

- (void)enabledToolbar:(BOOL)bEnable;

@end

#pragma mark - PHTextEditorToolbarDelegate

@protocol PHTextEditorToolbarDelegate <NSObject>

@optional

- (void)didSelectedKeyboard;
- (void)didSelectedFont;
- (void)didSelectedFontColor;

@end
