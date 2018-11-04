//
//  HESocketSender.m
//  IM
//
//  Created by jmhe on 2018/10/22.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketSender.h"
#import "HESocketRequestEncoder.h"
#import "HESocketDelimiterEncoder.h"

@interface HESocketSender()
@property (nonatomic, strong) NSOperationQueue *executeQueue;
@property (nonatomic,strong)NSMapTable *mapTable;
@end

@implementation HESocketSender

- (instancetype)shareInstance{
    static HESocketSender *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HESocketSender alloc]init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.executeQueue = [[NSOperationQueue alloc]init];
        self.mapTable = [NSMapTable strongToWeakObjectsMapTable];
    }
    return self;
}

- (void)sendRequest:(id<HESocketReqProtocol>)request
            success:(void (^)(HESocketTask *task, id<HESocketRespProtocol> resp))successBlock
            failure:(void (^)(HESocketTask *task, NSError *error))failuerBlock{
    HESocketTask *task = [HESocketTask taskWithRequest:request];
    task.successBlock = successBlock;
    task.failureBlock = failuerBlock;
    
    HESocketRequestEncoder *reqEncoder = [[HESocketRequestEncoder alloc]init];
    HESocketDelimiterEncoder *delimiterEncoder = [[HESocketDelimiterEncoder alloc]init];
    reqEncoder.next = delimiterEncoder;
    task.encoder = reqEncoder;
    [self.mapTable setObject:task forKey:@(task.taskId)];
    [self.executeQueue addOperation:task];
}


@end
