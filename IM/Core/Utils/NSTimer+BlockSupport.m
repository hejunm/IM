//
//  NSTimer+BlockSupport.m
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "NSTimer+BlockSupport.h"

@implementation NSTimer (BlockSupport)
+ (NSTimer *)heScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                       repeats:(BOOL)repeats
                                  handlerBlock:(void(^)(void))handler{
    
    NSTimer *timer = [self scheduledTimerWithTimeInterval:timeInterval
                                                   target:self
                                                 selector:@selector(handlerBlockInvoke:)
                                                 userInfo:[handler copy]
                                                  repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

+ (void)handlerBlockInvoke:(NSTimer *)timer{
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}
@end
