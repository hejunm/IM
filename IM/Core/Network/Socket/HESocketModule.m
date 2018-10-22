//
//  HESocketModule.m
//  IM
//
//  Created by jmhe on 2018/10/22.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketModule.h"
#import "HESocketHandler.h"
#import "HEMulticastDelegate.h"

@interface HESocketModule() <HESocketHandlerDelegate>
{
    void *moduleQueueTag;
}
@end

@implementation HESocketModule

- (instancetype)init{
    self = [super init];
    if (self) {
        const char *moduleQueueLabel = [[NSString stringWithFormat:@"%p_moduleQueueLabel", self] cStringUsingEncoding:NSUTF8StringEncoding];
        self.modultQueue = dispatch_queue_create(moduleQueueLabel, DISPATCH_QUEUE_SERIAL);
        moduleQueueTag = &moduleQueueTag;
        dispatch_queue_set_specific(self.modultQueue, moduleQueueTag, moduleQueueTag, NULL);
        self.multicastDelegate = [[HEMulticastDelegate alloc]init];
    }
    return self;
}
@end
