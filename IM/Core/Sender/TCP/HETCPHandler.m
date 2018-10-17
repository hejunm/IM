//
//  HETCPHandler.m
//  IM
//
//  Created by jmhe on 2018/10/17.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HETCPHandler.h"
#import "GCDAsyncSocket.h"

@interface HETCPHandler()<GCDAsyncSocketDelegate>
//初始化聊天
@property (strong , nonatomic) GCDAsyncSocket *chatSocket;
//所有的代理
@property (nonatomic, strong) NSMutableArray *delegates;
//心跳定时器
@property (nonatomic, strong) dispatch_source_t beatTimer;
//发送心跳次数
@property (nonatomic, assign) NSInteger sentBeatCount;

@end

@implementation HETCPHandler

+(instancetype) shareInstance{
    static HETCPHandler *Handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Handler = [[HETCPHandler alloc]init];
    });
    return Handler;
}

- (instancetype)init{
    if (self = [super init]) {
        _chatSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_chatSocket setAutoDisconnectOnClosedReadStream:NO];    //设置默认关闭读取
        _connectStatus = HESocketConnectStatus_UnConnected;      //默认状态未连接
        _delegates = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)addDelegate:(id<HETCPHandlerDelegate>)delegate{
    if (delegate && [delegate conformsToProtocol:@protocol(HETCPHandlerDelegate)]) {
        [self.delegates addObject:delegate];
    }
}

- (void)removeDelegate:(id<HETCPHandlerDelegate>)delegate{
    [self.delegates removeObject:delegate];
}

@end
