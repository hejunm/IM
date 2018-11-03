//
//  HESession.h
//  IM
//
//  Created by jmhe on 2018/10/17.
//  Copyright © 2018 贺俊孟. All rights reserved.
//  会话

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  会话类型
 */
typedef NS_ENUM(NSInteger, HESessionType){
    /**
     *  点对点
     */
    HESessionTypeP2P  = 0,
    /**
     *  群组
     */
    HESessionTypeTeam = 1,
    /**
     *  聊天室
     */
    HESessionTypeChatroom = 2
};

@interface HESession : NSObject
/**
 *  会话ID,如果当前session为team,则sessionId为teamId,如果是P2P则为对方帐号
 */
@property (nonatomic,copy,readonly)NSString *sessionId;

/**
 *  会话类型,当前仅支持P2P,Team和Chatroom
 */
@property (nonatomic,assign,readonly)HESessionType sessionType;

/**
 *  通过id和type构造会话对象
 *
 *  @param sessionId   会话ID
 *  @param sessionType 会话类型
 *
 *  @return 会话对象实例
 */
+ (instancetype)session:(NSString *)sessionId
                   type:(HESessionType)sessionType;
@end

NS_ASSUME_NONNULL_END
