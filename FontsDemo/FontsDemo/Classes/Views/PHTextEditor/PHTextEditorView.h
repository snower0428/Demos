//
//  PHTextEditorView.h
//  InstaSave
//
//  Created by leihui on 16/12/28.
//  Copyright © 2016年 ~. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PHTextEditorViewDelegate;

@interface PHTextEditorView : UIView

@property (nonatomic, assign) CGSize minSize;
@property (nonatomic, assign) CGFloat minFontSize;
@property (nonatomic, strong) UIFont *curFont;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, weak) id <PHTextEditorViewDelegate> delegate;

@end

#pragma mark - PHTextEditorViewDelegate

@protocol PHTextEditorViewDelegate <NSObject>

@optional

- (void)textEditorViewDidTapped:(PHTextEditorView *)textEditorView;
- (void)textEditorViewDidClose:(PHTextEditorView *)textEditorView;
- (void)textEditorViewTextDidChanged:(PHTextEditorView *)textEditorView;
- (void)textEditorViewDidEndEditing:(PHTextEditorView *)textEditorView;

@end
