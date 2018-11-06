//
//  HEIMSDK.m
//  IM
//
//  Created by jmhe on 2018/10/16.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HEIMSDK.h"

@interface HEIMSDK()
@property (nonatomic,strong,readwrite)HESocketSender *senderManager;
@property (nonatomic,strong)HESocketChannel *socketChannel;
@end

@implementation HEIMSDK

+ (instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setup{
    //创建连接
    HESocketConnectParam *connectParam = [[HESocketConnectParam alloc]init];
    connectParam.host = @"localhost";
    connectParam.port = 20162;
    self.socketChannel = [[HESocketChannel alloc]initWithConnectParam:connectParam];
    
    self.senderManager = [[HESocketSender alloc] initWithChannel:self.socketChannel];
    [self.socketChannel.delegate addDelegate:self.senderManager];
    [self.socketChannel openConnection];
    
    //网络监听
    
    
    
    //各种管理器的创建
}

@end
