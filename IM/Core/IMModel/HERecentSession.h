//
//  HERecentSession.h
//  IM
//
//  Created by jmhe on 2018/10/17.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HESession;
@class HEMessage;

NS_ASSUME_NONNULL_BEGIN

@interface HERecentSession : NSObject

/**
 *  当前会话
 */
@property (nullable,nonatomic,copy)   HESession  *session;

/**
 *  最后一条消息
 */
@property (nullable,nonatomic,strong)   HEMessage  *lastMessage;

/**
 *  未读消息数
 */
@property (nonatomic,assign)   NSInteger   unreadCount;

/**
 *  本地扩展
 */
@property (nullable,nonatomic,copy) NSDictionary *localExt;

@end

NS_ASSUME_NONNULL_END
