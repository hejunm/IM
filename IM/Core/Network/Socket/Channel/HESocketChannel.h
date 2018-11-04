//
//  HESocketChannel.h
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//
/**
    职责：
    接受数据--> 解码--> 得到response--> 将收到的数据传给task处理。
 */

#import <Foundation/Foundation.h>
#import "HESocketConnection.h"
#import "HESocketResponse.h"
#import "HEBaseEncoder.h"
#import "HEBaseDecoder.h"
@class HESocketChannel;

@protocol HESocketChannelDelegate <NSObject,HESocketConnectionDelegate>
- (void)channel:(HESocketChannel *)channel receivedPacket:(HESocketResponse *)response;
@end

@interface HESocketChannel : HESocketConnection

//多播代理
@property(nonatomic,strong)HEMulticastDelegate<HESocketChannelDelegate> *delegate;

//解码器
@property(nonatomic,strong)HEBaseDecoder *decoder;

+ (instancetype)sharedInstance;
@end

