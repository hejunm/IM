//
//  HESocketDelimiterEncoder.m
//  IM
//
//  Created by wulixiwa on 2018/11/3.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketDelimiterEncoder.h"
#import "NSData+Utils.h"

@implementation HESocketDelimiterEncoder

- (instancetype)init{
    if (self = [super init]) {
        _delimiterData = [NSData CRLFData];
        _maxFrameSize = 8192;
    }
    return self;
}

- (instancetype)initWithDelimiterData:(NSData *)delimiterData maxFrameSize:(NSUInteger)maxFrameSize{
    if (self = [super init]) {
        _delimiterData = delimiterData;
        _maxFrameSize = maxFrameSize;
    }
    return self;
}

- (id)encode:(id)packet error:(NSError * _Nullable __autoreleasing *)error{
    if (![packet isKindOfClass:[NSData class]]) {
        NSAssert(NO, @"HESocketDelimiterEncoder packet must be a NSData object");
        if ( error != NULL ){
            *error = [self createEncodeErrorWithCode:1 message:@"HESocketDelimiterEncoder packet must be a NSData object!"];
        }
        return nil;
    }
    
    NSData *data = (NSData *)packet;
    if (data.length == 0) {
        if ( error != NULL ){
            *error = [self createEncodeErrorWithCode:1 message:@"HESocketDelimiterEncoder 数据可以是空!"];
        }
        return nil;
    }
    
    if (data.length > self.maxFrameSize-self.delimiterData.length) {
        if ( error != NULL ){
            *error = [self createEncodeErrorWithCode:1 message:@"HESocketDelimiterEncoder Too Long Frame ...!"];
        }
        return nil;
    }
    
    NSMutableData *sendData = [[NSMutableData alloc]init];
    [sendData appendData:data];
    [sendData appendData:self.delimiterData];
    if (self.next) {
        return [self.next encode:sendData error:error];
    }else{
        return sendData;
    }
}
@end
