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
#import "HESocketReqProtocol.h"
#import "HESocketRespProtocol.h"

@class HESocketChannel;


@interface HESocketSender : NSObject

- (instancetype)initWithChannel:(HESocketChannel *)socketChannel;

- (void)sendRequest:(id<HESocketReqProtocol>)request
            success:(void (^)(HESocketTask *task, id<HESocketRespProtocol> resp))successBlock
            failure:(void (^)(HESocketTask *task, NSError *error))failuerBlock;
@end
