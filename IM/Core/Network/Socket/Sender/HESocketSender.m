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
#import "HEBaseDecoder.h"
#import "HESocketResponse.h"
#import "HESocketChannel.h"

@interface HESocketSender()<HESocketChannelDelegate>
@property (nonatomic,   strong)NSOperationQueue *executeQueue;
@property (nonatomic,   strong)NSMapTable *mapTable;
@property (nonatomic,   weak)HESocketChannel *socketChannel;
@end

@implementation HESocketSender

- (instancetype)initWithChannel:(HESocketChannel *)socketChannel{
    if (self = [super init]) {
        self.executeQueue = [[NSOperationQueue alloc]init];
        self.mapTable = [NSMapTable strongToWeakObjectsMapTable];
        self.socketChannel = socketChannel;
    }
    return self;
}

- (void)sendRequest:(id<HESocketReqProtocol>)request
            success:(void (^)(HESocketTask *task, id<HESocketRespProtocol> resp))successBlock
            failure:(void (^)(HESocketTask *task, NSError *error))failuerBlock{
    HESocketTask *task = [HESocketTask taskWithRequest:request];
    task.successBlock = successBlock;
    task.failureBlock = failuerBlock;
    task.socketChannel = self.socketChannel;
    
    HESocketRequestEncoder *reqEncoder = [[HESocketRequestEncoder alloc]init];
    HESocketDelimiterEncoder *delimiterEncoder = [[HESocketDelimiterEncoder alloc]init];
    reqEncoder.next = delimiterEncoder;
    task.encoder = reqEncoder;
    [self.mapTable setObject:task forKey:@(task.taskId)];
    [self.executeQueue addOperation:task];
}

#pragma mark - HESocketChannelDelegate
- (void)channel:(HESocketChannel *)channel receivedPacket:(HESocketResponse *)response{
    if(response.taskId == 0){ //服务器主动发的数据， 不是客户端请求的响应
        return;
    }
    HESocketTask *task = [self.mapTable objectForKey:@(response.taskId)];
    if (task == nil  || task.isCancelled) { //任务已经结束
        return;
    }
    [task receivedData:response.content];
}
@end
