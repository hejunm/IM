//
//  HETCPSocketService.h
//  IM
//
//  Created by jmhe on 2018/10/19.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HETCPSocketService : NSObject

/**
 服务器地址
 */
@property(nonatomic,copy)NSString *host;

/**
 端口号
 */
@property(nonatomic,assign)int16_t port;
@end
