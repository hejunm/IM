//
//  HETCPHandler.h
//  IM
//
//  Created by jmhe on 2018/10/17.
//  Copyright © 2018 贺俊孟. All rights reserved.
//



#import <Foundation/Foundation.h>

static NSString *const HETCPHandlerErrorDomain = @"XMPPStreamErrorDomain";

typedef NS_ENUM(NSInteger,HETCPHandlerState) {
    HETCPHandlerState_UnConnected = 0,  //未连接状态
    HETCPHandlerState_Connecting,       //正在连接    
    HETCPHandlerState_Connected,        //连接状态
    //HETCPHandlerState_DisconnectByUser  //主动断开连接
};

typedef NS_ENUM(NSUInteger, HETCPHandlerErrorCode) {
    HETCPHandlerInvalidType,       // Attempting to access P2P methods in a non-P2P stream, or vice-versa
    HETCPHandlerInvalidState,      // Invalid state for requested action, such as connect when already connected
    HETCPHandlerInvalidProperty,   // Missing a required property, such as myJID
    HETCPHandlerInvalidParameter,  // Invalid parameter, such as a nil JID
    HETCPHandlerUnsupportedAction, // The server doesn't support the requested action
};

@protocol HETCPHandlerDelegate <NSObject>
- (void)socketDidConnectToHost;
- (void)socketCanNotConnectToService;
@end

@interface HETCPHandler : NSObject

@property (nonatomic, assign) HETCPHandlerState state; //socket连接状态
@property (nonatomic,weak)id<HETCPHandlerDelegate> delegate;

+(instancetype)shareInstance;

- (void)setHost:(NSString *)host port:(uint16_t)port;

- (BOOL)connectWithTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr;

- (void)disconnect;

- (BOOL)isConnected;

- (void)writeData:(NSData *)data;

@end
