//
//  HESocketHeartbeatPolicy.h
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HESocketHeartbeatPolicy : NSObject

/**是否开启心跳*/
@property (nonatomic, assign) BOOL enabled;

/** 心跳定时间隔，默认为120秒*/
@property (nonatomic, assign) NSTimeInterval interval;

@end
