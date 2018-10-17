//
//  HELoginManagerProtocol.h
//  IM
//
//  Created by jmhe on 2018/10/16.
//  Copyright © 2018 贺俊孟. All rights reserved.
//  登录


#import "HELoginClient.h"

#ifndef HELoginManagerProtocol_h
#define HELoginManagerProtocol_h


/**
 *  登录服务相关Block
 *
 *  @param error 执行结果,如果成功error为nil
 */
typedef void(^HELoginHandler)(NSError * __nullable error);

/**
 *  登录步骤枚举
 */
typedef NS_ENUM(NSInteger, HELoginStep){
    /**
     *  连接服务器
     */
    HELoginStepLinking = 1,
    /**
     *  连接服务器成功
     */
    HELoginStepLinkOK,
    /**
     *  连接服务器失败
     */
    HELoginStepLinkFailed,
    /**
     *  登录
     */
    HELoginStepLogining,
    /**
     *  登录成功
     */
    HELoginStepLoginOK,
    /**
     *  登录失败
     */
    HELoginStepLoginFailed,
    /**
     *  开始同步
     */
    HELoginStepSyncing,
    /**
     *  同步完成
     */
    HELoginStepSyncOK,
    /**
     *  连接断开
     */
    HELoginStepLoseConnection,
    /**
     *  网络切换
     *  @discussion 这个并不是登录步骤的一种,但是UI有可能需要通过这个状态进行UI展现
     */
    HELoginStepNetChanged,
};

/**
 *  被踢下线的原因
 */
typedef NS_ENUM(NSInteger, HEKickReason){
    /**
     *  被另外一个客户端踢下线 (互斥客户端一端登录挤掉上一个登录中的客户端)
     */
    HEKickReasonByClient = 1,
    /**
     *  被服务器踢下线
     */
    HEKickReasonByServer = 2,
    /**
     *  被另外一个客户端手动选择踢下线
     */
    HEKickReasonByClientManually   = 3,
};

/**
 *  登录相关回调
 */
@protocol HELoginManagerDelegate <NSObject>

@optional
/**
 *  被踢(服务器/其他端)回调
 *
 *  @param code        被踢原因
 *  @param clientType  发起踢出的客户端类型
 */
- (void)onKick:(HEKickReason)code clientType:(HELoginClientType)clientType;

/**
 *  登录回调
 *
 *  @param step 登录步骤
 *  @discussion 这个回调主要用于客户端UI的刷新
 */
- (void)onLogin:(HELoginStep)step;

/**
 *  自动登录失败回调
 *
 *  @param error 失败原因
 *  @discussion 自动重连不需要上层开发关心，但是如果发生一些需要上层开发处理的错误，SDK 会通过这个方法回调
 *              用户需要处理的情况包括：AppKey 未被设置，参数错误，密码错误，多端登录冲突，账号被封禁，操作过于频繁等
 */
- (void)onAutoLoginFailed:(NSError *)error;

/**
 *  多端登录发生变化
 */
- (void)onMultiLoginClientsChanged;
@end


/**
 *  登录协议
 */
@protocol HELoginManager <NSObject>
/**
 *  登录
 *
 *  @param account    帐号
 *  @param token      令牌 (在后台绑定的登录token)
 *  @param completion 完成回调
 */
- (void)login:(NSString *)account
        token:(NSString *)token
   completion:(HELoginHandler)completion;

/**
 *  自动登录
 *
 *  @param account    帐号
 *  @param token      令牌 (在后台绑定的登录token)
 *  @discussion 启动APP如果已经保存了用户帐号和令牌,建议使用这个登录方式,使用这种方式可以在无网络时直接打开会话窗口
 *  非强制模式， 检查当前登录设备是否为上一次登录设备，如果不是，服务器将拒绝这次自动登录
 */
- (void)autoLogin:(NSString *)account
            token:(NSString *)token; 


/**
 *  自动登录
 *
 *  @param loginData 自动登录参数
 *  @discussion 启动APP如果已经保存了用户帐号和令牌,建议使用这个登录方式,使用这种方式可以在无网络时直接打开会话窗口
 */
- (void)autoLogin:(HEAutoLoginData *)loginData;

/**
 *  登出
 *
 *  @param completion 完成回调
 *  @discussion 用户在登出是需要调用这个接口进行 SDK 相关数据的清理,回调 Block 中的 error 只是指明和服务器的交互流程中可能出现的错误,但不影响后续的流程。
 *              如用户登出时发生网络错误导致服务器没有收到登出请求，客户端仍可以登出(切换界面，清理数据等)，但会出现推送信息仍旧会发到当前手机的问题。
 */
- (void)logout:(nullable HELoginHandler)completion;

/**
 *  踢人
 *
 *  @param client     当前登录的其他客户端
 *  @param completion 完成回调
 */
- (void)kickOtherClient:(HELoginClient *)client
             completion:(nullable HELoginHandler)completion;

/**
 *  返回当前登录帐号
 *
 *  @return 当前登录帐号,如果没有登录成功,这个地方会返回空字符串""
 */
- (NSString *)currentAccount;

/**
 *  当前登录状态
 *
 *  @return 当前登录状态
 */
- (BOOL)isLogined;

/**
 *  返回当前登录的设备列表
 *
 *  @return 当前登录设备列表 内部是HELoginClient,不包括自己
 */
- (nullable NSArray<HELoginClient *> *)currentLoginClients;

/**
 *  添加登录委托
 *
 *  @param delegate 登录委托
 */
- (void)addDelegate:(id<HELoginManagerDelegate>)delegate;

/**
 *  移除登录委托
 *
 *  @param delegate 登录委托
 */
- (void)removeDelegate:(id<HELoginManagerDelegate>)delegate;
@end

#endif /* HELoginManagerProtocol_h */
