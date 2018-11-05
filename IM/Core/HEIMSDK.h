//
//  HEIMSDK.h
//  IM
//
//  Created by jmhe on 2018/10/16.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HELoginManagerProtocol.h"
#import "HEUserManagerProtocol.h"
#import "HEChatManagerProtocol.h"
#import "HEConversationManagerProtocol.h"
#import "HETeamManagerProtocol.h"
#import "HEChatroomManagerProtocol.h"
#import "HERedPacketManagerProtocol.h"
#import "HEResourceManagerProtocol.h"
#import "HEMediaManagerProtocol.h"
#import "HEDocTranscodingManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HEIMSDK : NSObject

/**登录管理*/
@property(nonatomic,strong)id<HELoginManagerProtocol>loginManager;

/**好友管理*/
@property(nonatomic,strong)id<HEUserManagerProtocol>userManager;

/**聊天管理*/
@property(nonatomic,strong)id<HEChatManagerProtocol>chatManager;

/**会话管理*/
@property(nonatomic,strong)id<HEConversationManagerProtocol>conversationManager;

/**资源管理*/
@property(nonatomic,strong)id<HEResourceManagerProtocol>resourceManager;


//@property(nonatomic,strong)id<HETeamManagerProtocol>teamManager;
//@property(nonatomic,strong)id<HEChatroomManagerProtocol>chatroomManager;
//@property(nonatomic,strong)id<HERedPacketManagerProtocol>redPacketManager;
//@property(nonatomic,strong)id<HEMediaManagerProtocol>mediaManager;
//@property(nonatomic,strong)id<HEDocTranscodingManagerProtocol>docTranscodingManager;
@end

NS_ASSUME_NONNULL_END
