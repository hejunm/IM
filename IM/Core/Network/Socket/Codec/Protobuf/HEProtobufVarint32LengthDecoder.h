//
//  HEProtobufVarint32LengthDecoder.h
//  IM
//
//  Created by wulixiwa on 2018/11/3.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HEBaseDecoder.h"

NS_ASSUME_NONNULL_BEGIN

@interface HEProtobufVarint32LengthDecoder : HEBaseDecoder
/**
 *  应用协议中允许发送的最大数据块大小，默认为INT32_MAX
 */
@property (nonatomic, assign) NSUInteger maxFrameSize;

@end

NS_ASSUME_NONNULL_END
