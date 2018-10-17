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
