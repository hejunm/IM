//
//  HESocketHandler.h
//  IM
//
//  Created by jmhe on 2018/10/17.
//  Copyright © 2018 贺俊孟. All rights reserved.
//



#import <Foundation/Foundation.h>
@class HESocketModule;

static NSString *const HESocketHandlerErrorDomain = @"XMPPStreamErrorDomain";

typedef NS_ENUM(NSInteger,HESocketHandlerState) {
    HESocketHandlerState_UnConnected = 0,  //未连接状态
    HESocketHandlerState_Connecting,       //正在连接    
    HESocketHandlerState_Connected,        //连接状态
    //HESocketHandlerState_DisconnectByUser  //主动断开连接
};

typedef NS_ENUM(NSUInteger, HESocketHandlerErrorCode) {
    HESocketHandlerInvalidType,       // Attempting to access P2P methods in a non-P2P stream, or vice-versa
    HESocketHandlerInvalidState,      // Invalid state for requested action, such as connect when already connected
    HESocketHandlerInvalidProperty,   // Missing a required property, such as myJID
    HESocketHandlerInvalidParameter,  // Invalid parameter, such as a nil JID
    HESocketHandlerUnsupportedAction, // The server doesn't support the requested action
};

@protocol HESocketHandlerDelegate <NSObject>
- (void)socketDidConnectToHost:(NSString *)host port:(uint16_t)port;
- (void)socketDidDisconnectWithError:(NSError *)error;
@end

@interface HESocketHandler : NSObject

@property (nonatomic, assign) HESocketHandlerState state; //socket连接状态

+(instancetype)shareInstance;

- (void)setHost:(NSString *)host port:(uint16_t)port;

- (BOOL)connectWithTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr;

- (void)disconnect;

- (BOOL)isConnected;

- (void)writeData:(NSData *)data;

#pragma mark Module
- (void)registerModule:(HESocketModule *)module;
- (void)unregisterModule:(HESocketModule *)module;
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue toModulesOfClass:(Class)aClass;
- (void)removeDelegate:(id)delegate fromModulesOfClass:(Class)aClass;
@end
