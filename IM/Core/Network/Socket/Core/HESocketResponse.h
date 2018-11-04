//
//  HESocketResponse.h
//  IM
//
//  Created by jmhe on 2018/10/18.
//  Copyright © 2018 贺俊孟. All rights reserved.
//
/**
 解码后的包。包含apiCode,taskId.
 content中是真正的数据。 需要上层处理解析。
 */

#import <Foundation/Foundation.h>


@interface HESocketResponse : NSObject

/**类似http中的url，标示某个接口*/
@property(nonatomic,assign)uint32_t apiCode;

/**标记某个请求 服务器主动发起请求时为0*/
@property(nonatomic,assign)uint32_t taskId;

/**消息长度*/
@property(nonatomic,assign)NSUInteger contentLength;

/**响应消息内容*/
@property(nonatomic,strong)NSData *content;

@end

