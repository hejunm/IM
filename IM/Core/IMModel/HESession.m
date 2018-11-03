//
//  HESession.m
//  IM
//
//  Created by jmhe on 2018/10/17.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESession.h"

@interface HESession()
@property (nonatomic,copy,readwrite)NSString *sessionId;
@property (nonatomic,assign,readwrite)HESessionType sessionType;
@end

@implementation HESession
+ (instancetype)session:(NSString *)sessionId
                   type:(HESessionType)sessionType{
    HESession *session = [[HESession alloc]init];
    session.sessionId = sessionId;
    session.sessionType = sessionType;
    return session;
}
@end
