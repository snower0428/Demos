//
//  EOCEmployer.h
//  GCDDemo
//
//  Created by leihui on 2017/9/29.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EOCPerson;

@interface EOCEmployer : NSObject

- (void)addEmployee:(EOCPerson *)person;
- (void)removeEmployee:(EOCPerson *)person;

@end
