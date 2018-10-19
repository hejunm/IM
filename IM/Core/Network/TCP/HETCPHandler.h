//
//  HETCPHandler.h
//  IM
//
//  Created by jmhe on 2018/10/17.
//  Copyright © 2018 贺俊孟. All rights reserved.
//



#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HESocketConnectStatus) {
    HESocketConnectStatus_UnConnected       = 0,//未连接状态
    HESocketConnectStatus_Connected         = 1,//连接状态
    //HESocketConnectStatus_DisconnectByUser  = 2,//主动断开连接
    HESocketConnectStatus_Unknow            = 3 //未知
};

@protocol HETCPHandlerDelegate <NSObject>
- (void)socketDidConnectToHost;
- (void)socketCanNotConnectToService;
@end

@interface HETCPHandler : NSObject

@property (nonatomic, assign) HESocketConnectStatus connectStatus; //socket连接状态
@property (nonatomic,weak)id<HETCPHandlerDelegate> delegate;

+(instancetype)shareInstance;

- (void)setHost:(NSString *)host port:(uint16_t)port;

- (void)disconnect;

- (BOOL)isConnected;

- (void)writeData:(NSData *)data;

@end
