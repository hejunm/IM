//
//  HETeamMessageReceiptDetail.h
//  IM
//
//  Created by jmhe on 2018/10/17.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  群已读回执详情
 */

@interface HETeamMessageReceiptDetail : NSObject
/**
 *  所属消息 Id
 */
@property (nonatomic, copy, readonly) NSString *messageId;

/**
 *  所属会话 Id
 */
@property (nonatomic, copy, readonly) NSString *sessionId;

/**
 *  已读用户列表
 */
@property (nonatomic, copy, readonly) NSArray *readUserIds;

/**
 *  未读用户列表
 */
@property (nonatomic, copy, readonly) NSArray *unreadUserIds;

@end

NS_ASSUME_NONNULL_END
