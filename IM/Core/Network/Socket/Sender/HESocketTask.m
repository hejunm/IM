//
//  HESocketTask.m
//  IM
//
//  Created by jmhe on 2018/10/24.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketTask.h"
#import "HETaskIdGenerator.h"
#import "HESocketRequestEncoder.h"
#import "HESocketDelimiterEncoder.h"
#import "HESocketChannel.h"

@interface HESocketTask()

@property(nonatomic,assign,readwrite)uint32_t taskId;   //任务id
@property(nonatomic,strong,readwrite)id<HESocketReqProtocol>request;
@property(nonatomic,strong,readwrite)id<HESocketRespProtocol>response;

@property(nonatomic,strong)NSData *responseData;


//#pragma mark - 错误信息
//@property (nonatomic, readwrite) BOOL isTaskSuccess;   //网络请求是否成功
//@property (nonatomic, readwrite) BOOL isServerSuccess; // API请求是否成功
@property (nonatomic, readwrite) NSError *error;
//
//#pragma mark 时间统计
//@property (nonatomic, readwrite) NSTimeInterval totalTime; //服务总时间 ms 一般会稍大于以下三个时间的总和
//@property (nonatomic, readwrite) NSTimeInterval serializeTime;   //序列化时间 ms
//@property (nonatomic, readwrite) NSTimeInterval deserializeTime; //反序列化时间 ms
//@property (nonatomic, readwrite) NSTimeInterval serviceTime;     //请求总耗时（RTT） ms
//
//#pragma mark 网络状态
//@property (nonatomic, readwrite) NSString *startNetworkStatus;               //发起请求时网络状态
//@property (nonatomic, readwrite) NSString *endNetworkStatus;                 //请求结束时网络状态
//@property (nonatomic, readwrite, getter=isChangedStatus) BOOL changedStatus; //请求过程中网络状态是否变化
//
//#pragma mark 数据大小（解压后）
//@property (nonatomic, readwrite) NSUInteger responseSize; //返回大小B
//@property (nonatomic, readwrite) NSUInteger requestSize;  //请求体大小B
//
//#pragma mark 重试
///// 连接重试次数
//@property (nonatomic, readwrite) NSUInteger connectionRetryCount;
//@property (nonatomic, readwrite) NSUInteger requestCount; //请求次数
//@property (nonatomic, readwrite) NSUInteger retryCount; //重试次数

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_semaphore_t queueSemaphore;

@end

@implementation HESocketTask
+ (instancetype)taskWithRequest:(id<HESocketReqProtocol>)request{
    HESocketTask *task = [[HESocketTask alloc]initWithRequest:request];
    return task;
}

- (instancetype)initWithRequest:(id<HESocketReqProtocol>)request{
    if (self = [super init]) {
        if (![request conformsToProtocol:@protocol(HESocketReqProtocol)]) {
            NSAssert(NO, @"request must conformsToProtocol HESocketReqProtocol");
        }
        self.taskId = [[HETaskIdGenerator shareInstance] createId];
        [request setTaskId:self.taskId];
        self.request = request;
        
        self.semaphore = dispatch_semaphore_create(0);
        self.queueSemaphore = dispatch_semaphore_create(1);
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
    NSData *encodedData = [self.encoder encode:self.request error:&error];
    if (error) {
        self.error = error;
        [self dispatchOnMainQueue:^{
            self.failureBlock(self, self.error);
        }];
        return;
    }
    
    //--- 发起服务 ---
    [self.socketChannel writeData:encodedData timeout:-1 tag:0];
    [self sleep];
    
    if (self.cancelled) {
        return;
    }
    //--- 服务结束，反序列化 ---
    NSString *responseClassName;
    if ([self.request respondsToSelector:@selector(responseClassName)]) {
        responseClassName = [self.request responseClassName];
    }
    if (responseClassName.length==0) {
        NSAssert(NO,@"一个请求必须指定一个response class");
    }
    id response;
    Class responseClass = NSClassFromString(responseClassName);
    if ([responseClass respondsToSelector:@selector(responseModelWithData:)]) {
        response = [responseClass responseModelWithData:self.responseData];
    }
    if (response) {
        self.response = response;
        [self dispatchOnMainQueue:^{
            self.successBlock(self, response);
        }];
    }else{//解析失败
        self.error = [NSError errorWithDomain:@"数据解析出错" code:1 userInfo:nil];
        [self dispatchOnMainQueue:^{
            self.failureBlock(self, self.error);
        }];
    }
}

- (void)cancel{
    [super cancel];
}

- (void)dispatchOnMainQueue:(dispatch_block_t)block{
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            block();
        }
    });
}

//接受到响应数据
- (void)receivedData:(NSData *)data{
    dispatch_semaphore_wait(self.queueSemaphore, DISPATCH_TIME_FOREVER);
    self.responseData = data;
    dispatch_semaphore_signal(self.queueSemaphore);
    [self weakup];
}

- (void)sleep{
   dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER); 
}

- (void)weakup{
    dispatch_semaphore_signal(self.semaphore);
}
@end
