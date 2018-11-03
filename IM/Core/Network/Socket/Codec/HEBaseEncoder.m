//
//  HEBaseEncoder.m
//  IM
//
//  Created by jmhe on 2018/11/2.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HEBaseEncoder.h"

@implementation HEBaseEncoder
- (id)encode:(id)packet error:(NSError **)error{
    return nil;
}

- (NSError *)createEncodeErrorWithMessage:(NSString *)msg{
    NSDictionary *userInfo = @{@"msg":msg?:@""};
    return  [NSError errorWithDomain:@"EncodeErrorDomain" code:1 userInfo:userInfo];
}
@end
