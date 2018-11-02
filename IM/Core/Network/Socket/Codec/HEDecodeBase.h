//
//  HEDecodeBase.h
//  IM
//
//  Created by jmhe on 2018/11/2.
//  Copyright © 2018 贺俊孟. All rights reserved.
//  解码器基类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HEDecodeBase : NSObject

/**下一个解码器*/
@property(nonatomic,strong)HEDecodeBase *next;

/**
 解码

 @param packet  待解码数据
 @param error   解码过程出错
 @return        解码后数据
 */
- (id)decodePacket:(id)packet error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
