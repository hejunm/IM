//
//  HEReqBase.h
//  IM
//
//  Created by jmhe on 2018/10/24.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HEReqHeader.h"
#import "HESocketReqProtocol.h"
#import "HESocketRespProtocol.h"
#import "JSONModel.h"

@interface HEReqBase : JSONModel<HESocketReqProtocol,HESocketRespProtocol>

+ (instancetype)reqeustEntity;

#pragma mark - 参数
@property(nonatomic,strong)HEReqHeader *header;

#pragma mark - 配置信息参数

#pragma mark - 子类重写

@end
