//
//  HEReqBase.h
//  IM
//
//  Created by jmhe on 2018/10/24.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HEReqHeader.h"

@interface HEReqBase : NSObject

+ (instancetype)reqeustEntity;

#pragma mark - 参数
@property(nonatomic,strong)HEReqHeader *header;

#pragma mark - 配置信息参数
//缓存策略
//重试策略

#pragma mark - 子类重写
- (NSUInteger)apiCode;
- (NSData *)serializeToData;
- (NSString *)responseClassName;
@end
