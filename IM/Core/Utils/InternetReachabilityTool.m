//
//  InternetReachabilityTool.m
//  IM
//
//  Created by jmhe on 2018/10/19.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "InternetReachabilityTool.h"
#import "Reachability.h"

@interface InternetReachabilityTool()
@property(nonatomic,strong)Reachability *internetConnectionReach;
@end

@implementation InternetReachabilityTool

+(instancetype) shareInstance{
    static InternetReachabilityTool *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[InternetReachabilityTool alloc]init];
        share.internetConnectionReach = [Reachability reachabilityForInternetConnection];
        [share.internetConnectionReach startNotifier];
    });
    return share;
}

-(BOOL)isReachable{
    return [self.internetConnectionReach isReachable];
}

-(BOOL)isReachableViaWWAN{
    return [self.internetConnectionReach isReachableViaWWAN];
}

-(BOOL)isReachableViaWiFi{
    return [self.internetConnectionReach isReachableViaWiFi];
}
@end
