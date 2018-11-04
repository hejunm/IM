//
//  HEReqBase.m
//  IM
//
//  Created by jmhe on 2018/10/24.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HEReqBase.h"
#import "HESocketTask.h"

@interface HEReqBase()

@end

@implementation HEReqBase

+ (instancetype)reqeustEntity{
    return [[self alloc]init];
}

#pragma mark - HESocketReqProtocol
- (uint32_t)apiCode{
    return 0;
}
- (void)setTaskId:(uint32_t)taskId{
    self.header.taskId = taskId;
}

- (uint32_t)taskId{
     return self.header.taskId;
}

- (NSData *)serializeToData{
    return nil;
}
- (NSString *)responseClassName{
    return nil;
}
@end
