//
//  LoadImageOperation.m
//  GCDDemo
//
//  Created by leihui on 2017/9/26.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "LoadImageOperation.h"

@implementation LoadImageOperation

- (void)main
{
	if (self.isCancelled) {
		return;
	}
	
	NSURL *url = [NSURL URLWithString:_imageUrl];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *image = [UIImage imageWithData:imageData];
	if (image) {
		if (_delegate && [_delegate respondsToSelector:@selector(loadImageFinish:)]) {
			[(NSObject *)_delegate performSelectorOnMainThread:@selector(loadImageFinish:) withObject:image waitUntilDone:NO];
		}
	}
}

@end
