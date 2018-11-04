//
//  HETaskIdGenerator.m
//  IM
//
//  Created by jmhe on 2018/10/24.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HETaskIdGenerator.h"

@interface HETaskIdGenerator()
@property(nonatomic,assign)uint32_t currentIndex;
@end

@implementation HETaskIdGenerator

+(instancetype) shareInstance{
    static HETaskIdGenerator *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HETaskIdGenerator alloc]init];
    });
    return instance;
}

- (instancetype)init{
    if(self = [super init]){
        self.currentIndex = 1;
    }
    return self;
}

- (uint32_t)createId{
    @synchronized(self) {
        
        if (self.currentIndex == UINT32_MAX) {
            self.currentIndex = 1;
        }
        return self.currentIndex++;
    }
}


@end
