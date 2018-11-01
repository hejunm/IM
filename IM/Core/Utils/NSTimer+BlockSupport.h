//
//  NSTimer+BlockSupport.h
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (BlockSupport)
+ (NSTimer *)heScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                      repeats:(BOOL)repeats
                                 handlerBlock:(void(^)(void))handler;
@end

NS_ASSUME_NONNULL_END
