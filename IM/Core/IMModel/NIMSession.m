//
//  HESession.m
//  IM
//
//  Created by jmhe on 2018/10/17.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "NIMSession.h"

@interface NIMSession()
@property (nonatomic,copy,readwrite)NSString *sessionId;
@property (nonatomic,assign,readwrite)NIMSessionType sessionType;
@end

@implementation NIMSession

+ (instancetype)session:(NSString *)sessionId
                   type:(NIMSessionType)sessionType{
    NIMSession *session = [[NIMSession alloc]init];
    session.sessionId = sessionId;
    session.sessionType = sessionType;
    return session;
}

- (id)copyWithZone:(nullable NSZone *)zone{
    NIMSession *copySession = [NIMSession session:self.sessionId type:self.sessionType];
    return copySession;
}


@end
