//
//  HERespBase.m
//  IM
//
//  Created by jmhe on 2018/10/24.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HERespBase.h"
#import "YYModel.h"

@implementation HERespBase

+ (id)responseModelWithData:(NSData *)data{
    return [self yy_modelWithJSON:data];
}

@end
