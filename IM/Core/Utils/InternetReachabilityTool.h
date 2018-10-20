//
//  InternetReachabilityTool.h
//  IM
//
//  Created by jmhe on 2018/10/19.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternetReachabilityTool : NSObject
+(instancetype) shareInstance;
-(BOOL)isReachable;
-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;
@end
