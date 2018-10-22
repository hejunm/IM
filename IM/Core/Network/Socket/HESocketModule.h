//
//  HESocketModule.h
//  IM
//
//  Created by jmhe on 2018/10/22.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HEMulticastDelegate;
@class HESocketHandler;

@interface HESocketModule : NSObject
{
    void *moduleQueueTag;
}
@property(nonatomic,weak)HESocketHandler *socketHandler;
@property (nonatomic, strong) dispatch_queue_t modultQueue;
@property (nonatomic,strong)HEMulticastDelegate *multicastDelegate;
@end
