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
- (void)didReceiveData:(NSDictionary *)dict type:(NSUInteger)type;
@end

@interface HETCPHandler : NSObject

@property (nonatomic, assign) HESocketConnectStatus connectStatus; //socket连接状态

+(instancetype)shareInstance;

- (void)addDelegate:(id<HETCPHandlerDelegate>)delegate;

- (void)removeDelegate:(id<HETCPHandlerDelegate>)delegate;

@end



/**
 设计思路
 https://www.jianshu.com/p/2f98823730a8
 1，如何保证服务器正确的处理了客户端发的请求？
    TCP作为传输层协议，可以保证请求数据可靠的传输到服务端。 但是这不代表服务器正常的处理了这个请求。
    https://www.zhihu.com/question/25016042
    所以客户端发送请求，服务器一定要有对应的响应。所以在设计网络请求类时，发请求的方法要有block回掉。
     TCP的block如何实现？
 2，服务器主动发送客户端的数据，也要ack。通过delegate接收数据。
 3，
 
 */
