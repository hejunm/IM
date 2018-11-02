//
//  HESocketTask.h
//  IM
//
//  Created by jmhe on 2018/10/24.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HESocketReqProtocol.h"
#import "HESocketRespProtocol.h"
#import "HEReqBase.h"
#import "HERespBase.h"

@interface HESocketTask : NSOperation
@property(nonatomic,strong,readonly)id<HESocketReqProtocol>request;

@property(nonatomic,strong,readonly)id<HESocketRespProtocol>response;

#pragma mark - 错误信息
@property (nonatomic, readonly) BOOL isTaskSuccess;   //网络请求是否成功
@property (nonatomic, readonly) BOOL isServerSuccess; // API请求是否成功
@property (nonatomic, readonly) NSError *error;

#pragma mark 时间统计
@property (nonatomic, readonly) NSTimeInterval totalTime; //服务总时间 ms 一般会稍大于以下三个时间的总和
@property (nonatomic, readonly) NSTimeInterval queueWaitingTime;//任务分发时间
@property (nonatomic, readonly) NSTimeInterval serializeTime;   //序列化时间 ms
@property (nonatomic, readonly) NSTimeInterval deserializeTime; //反序列化时间 ms
@property (nonatomic, readonly) NSTimeInterval serviceTime;     //请求总耗时（RTT） ms

#pragma mark 网络状态
@property (nonatomic, readonly) NSString *startNetworkStatus;               //发起请求时网络状态
@property (nonatomic, readonly) NSString *endNetworkStatus;                 //请求结束时网络状态
@property (nonatomic, readonly, getter=isChangedStatus) BOOL changedStatus; //请求过程中网络状态是否变化

#pragma mark 数据大小（解压后）
@property (nonatomic, readonly) NSUInteger responseSize; //返回大小B
@property (nonatomic, readonly) NSUInteger requestSize;  //请求体大小B

#pragma mark 重试
/// 连接重试次数
@property (nonatomic, readonly) NSUInteger connectionRetryCount;
@property (nonatomic, readonly) NSUInteger requestCount; //请求次数
@property (nonatomic, readonly) NSUInteger retryCount; //重试次数

#pragma mark - Action
@property (nonatomic, copy) void (^successBlock)(HESocketTask *task, id<HESocketRespProtocol>resp);
@property (nonatomic, copy) void (^failureBlock)(HESocketTask *task, NSError *error);

+ (instancetype)taskWithRequest:(HEReqBase *)request;
@end
