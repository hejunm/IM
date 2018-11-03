//
//  HESocketDelimiterEncoder.h
//  IM
//
//  Created by wulixiwa on 2018/11/3.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HEBaseEncoder.h"

NS_ASSUME_NONNULL_BEGIN

@interface HESocketDelimiterEncoder : HEBaseEncoder


/**应用协议中每帧数据之间的标记分隔符号*/
@property (nonatomic,strong)NSData *delimiterData;

/** 应用协议中允许发送的最大数据块大小，默认为8192*/
@property (nonatomic,assign)NSUInteger maxFrameSize;

- (instancetype)initWithDelimiterData:(NSData *)delimiterData maxFrameSize:(NSUInteger)maxFrameSize;

@end

NS_ASSUME_NONNULL_END
