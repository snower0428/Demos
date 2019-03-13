//
//  LHAlertView.h
//  GCDDemo
//
//  Created by leihui on 2017/9/30.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewBlock) (NSInteger index);

@interface LHAlertView : UIAlertView

- (instancetype)initWithTitle:(NSString *)title
					  message:(NSString *)message
						block:(AlertViewBlock)block
			cancelButtonTitle:(NSString *)cancelButtonTitle
			otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
