//
//  HESocketRequestEntity.h
//  IM
//
//  Created by jmhe on 2018/10/18.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HESocketRequestEntity : NSObject

/**类似http中的url，标示某个接口*/
@property(nonatomic,assign)NSUInteger apiCode;

/**标记某个请求*/
@property(nonatomic,assign)NSUInteger reqId;

/**发送消息内容 */
@property(nonatomic,strong)NSData *contentData;

/**接受到服务器数据后的回调*/
@property (nonatomic, copy) void (^successBlock)(NSData *respData);

/**失败后回调*/
@property (nonatomic, copy) void (^failureBlock)(NSError *error);

/**
 数据装包，TCP发送的数据

 @return 封装好的数据
 */
- (NSData *)packData;

@end
