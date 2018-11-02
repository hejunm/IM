//
//  HESocketTask.m
//  IM
//
//  Created by jmhe on 2018/10/24.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketTask.h"
#import "HETaskIdGenerator.h"

@interface HESocketTask()

@property(nonatomic,assign)NSUInteger identifier;   //任务id

@property(nonatomic,strong,readwrite)id<HESocketReqProtocol>request;
@property(nonatomic,strong,readwrite)id<HESocketRespProtocol>response;

#pragma mark - 错误信息
@property (nonatomic, readwrite) BOOL isTaskSuccess;   //网络请求是否成功
@property (nonatomic, readwrite) BOOL isServerSuccess; // API请求是否成功
@property (nonatomic, readwrite) NSError *error;

#pragma mark 时间统计
@property (nonatomic, readwrite) NSTimeInterval totalTime; //服务总时间 ms 一般会稍大于以下三个时间的总和
@property (nonatomic, readwrite) NSTimeInterval serializeTime;   //序列化时间 ms
@property (nonatomic, readwrite) NSTimeInterval deserializeTime; //反序列化时间 ms
@property (nonatomic, readwrite) NSTimeInterval serviceTime;     //请求总耗时（RTT） ms

#pragma mark 网络状态
@property (nonatomic, readwrite) NSString *startNetworkStatus;               //发起请求时网络状态
@property (nonatomic, readwrite) NSString *endNetworkStatus;                 //请求结束时网络状态
@property (nonatomic, readwrite, getter=isChangedStatus) BOOL changedStatus; //请求过程中网络状态是否变化

#pragma mark 数据大小（解压后）
@property (nonatomic, readwrite) NSUInteger responseSize; //返回大小B
@property (nonatomic, readwrite) NSUInteger requestSize;  //请求体大小B

#pragma mark 重试
/// 连接重试次数
@property (nonatomic, readwrite) NSUInteger connectionRetryCount;
@property (nonatomic, readwrite) NSUInteger requestCount; //请求次数
@property (nonatomic, readwrite) NSUInteger retryCount; //重试次数


@end

@implementation HESocketTask
+ (instancetype)taskWithRequest:(id<HESocketReqProtocol>)request{
    HESocketTask *task = [[HESocketTask alloc]initWithRequest:request];
    return task;
}

- (instancetype)initWithRequest:(id<HESocketReqProtocol>)request{
    if (self = [super init]) {
        self.request = request;
        self.identifier = [[HETaskIdGenerator shareInstance] createId];
    }
    return self;
}

- (void)main{
    @autoreleasepool {
        if (self.isCancelled) {
            return;
        }
        [self excute];
    }
}

- (void)excute{
    //--- 追踪错误 ---
    NSError *error;
    
    //--- 序列化（拼装）请求 ---
    
    //--- 发起服务（RTT统计） ---
    
    //wait();
    
    //--- 服务结束，反序列化 ---
    
    // 流程完成后 设置task状态
    self.isTaskSuccess = YES;
    
    
}

- (void)cancel{
    [super cancel];
}
@end
