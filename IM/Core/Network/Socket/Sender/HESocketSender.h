//
//  HESocketSender.h
//  IM
//
//  Created by jmhe on 2018/10/22.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HESocketTask.h"
#import "HEReqBase.h"
#import "HERespBase.h"

@interface HESocketSender : NSObject
- (instancetype)shareInstance;
- (void)sendRequest:(HEReqBase *)request
            success:(void (^)(HESocketTask *task, __kindof HERespBase *resp))successBlock
            failure:(void (^)(HESocketTask *task, NSError *error))failuerBlock;
@end
