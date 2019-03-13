//
//  EOCPerson.h
//  GCDDemo
//
//  Created by leihui on 2017/9/29.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EOCEmployer;

@interface EOCPerson : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, strong) EOCEmployer *employer;

@end
