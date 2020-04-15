//
//  VideoDetailSectionModel.m
//  FLDemos
//
//  Created by leihui on 2020/2/10.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "VideoDetailSectionModel.h"

@implementation VideoDetailItem

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id)object {
    // since the diff identifier returns self, object should only be compared with same instance
    return self == object;
}

@end

@implementation VideoDetailSectionModel

#pragma mark - IGListDiffable

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id)object {
    // since the diff identifier returns self, object should only be compared with same instance
    return self == object;
}

@end
