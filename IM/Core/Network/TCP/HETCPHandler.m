//
//  HETCPHandler.m
//  IM
//
//  Created by jmhe on 2018/10/17.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HETCPHandler.h"
#import "GCDAsyncSocket.h"
#import "HETCPSocketService.h"

@interface HETCPHandler()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) dispatch_queue_t delegateQueue;

//初始化聊天
@property (strong , nonatomic)GCDAsyncSocket *socket;
//TCP地址
@property (nonatomic,copy)NSString *host;
//TCP端口后
@property (nonatomic,assign)uint16_t port;
//心跳定时器
@property (nonatomic, strong) dispatch_source_t beatTimer;
//发送心跳次数
@property (nonatomic, assign) NSInteger sentBeatCount;
//服务器列表
@property (nonatomic,strong)NSArray<HETCPSocketService *> *serviceArray;

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
        const char *delegateQueueLabel = [[NSString stringWithFormat:@"%p_socketDelegateQueue", self] cStringUsingEncoding:NSUTF8StringEncoding];
        _delegateQueue = dispatch_queue_create(delegateQueueLabel, DISPATCH_QUEUE_SERIAL);
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.delegateQueue];
        [_socket setAutoDisconnectOnClosedReadStream:NO];    //设置默认关闭读取
        _connectStatus = HESocketConnectStatus_UnConnected;      //默认状态未连接
    }
    return self;
}

#pragma mark - 连接
- (void)setHost:(NSString *)host port:(uint16_t)port{
    self.host = host;
    self.port = port;
}

- (BOOL)isConnected{
    return self.socket.isConnected;
}

- (void)disconnect{
    if (!self.socket.isConnected) {
        return;
    }
    [self.socket setDelegate:nil delegateQueue:nil];
    [self.socket disconnect];
}

- (void)tryToReconnect{
    BOOL isNetworkReachable = [InternetReachabilityTool shareInstance].isReachable;
    if (!isNetworkReachable) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(socketCanNotConnectToService)]) {
            [self.delegate socketCanNotConnectToService];
        }
        return;
    }
}


#pragma mark - 心跳


#pragma mark - 发送数据
- (void)writeData:(NSData *)data{
    
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    DebugLog(@"TCPSocket连接成功...");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error {
    DebugLog(@"TCPSocket连接已断开...%@", error);
    [self tryToReconnect];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
}

#pragma mark - 接受数据

@end
