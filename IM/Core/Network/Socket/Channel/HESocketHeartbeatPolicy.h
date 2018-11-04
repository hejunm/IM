//
//  HESocketHeartbeatPolicy.h
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//  

#warning TODO: 重试次数，间隔参数需要查资料，调优!

#import <Foundation/Foundation.h>

@interface HESocketHeartbeatPolicy : NSObject

/**是否开启心跳*/
@property (nonatomic, assign) BOOL enabled;

/** 心跳定时间隔，默认为120秒*/
@property (nonatomic, assign) NSTimeInterval interval;

/** 当没有收到resp时，最大重试次数 默认5次*/
@property (nonatomic, assign) NSUInteger maxRetryCount;

/**当前重试次数*/
@property (nonatomic, assign) NSUInteger currentRetryCount;

/**重试延迟时间 默认10s*/
@property (nonatomic,assign)NSTimeInterval retryDelay;
@end
