//
//  HEProtobufVarint32LengthEncoder.m
//  IM
//
//  Created by wulixiwa on 2018/11/3.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HEProtobufVarint32LengthEncoder.h"
#import "NSData+Utils.h"

@implementation HEProtobufVarint32LengthEncoder
- (instancetype)init{
    if (self = [super init]) {
        _maxFrameSize = INT32_MAX;
    }
    return self;
}

- (id)encode:(id)packet error:(NSError *__autoreleasing *)error{
    
    if (![packet isKindOfClass:[NSData class]]) {
        NSAssert(NO, @"HEProtobufVarint32LengthEncoder packet must be a NSData object");
        if ( error != NULL ){
            *error = [self createEncodeErrorWithCode:1 message:@"HEProtobufVarint32LengthEncoder packet must be a NSData object!"];
        }
        return nil;
    }
    
    NSData *data = (NSData *)packet;
    if (data.length >= _maxFrameSize - 4) {
        if ( error != NULL ){
            *error = [self createEncodeErrorWithCode:1 message:@"HEProtobufVarint32LengthEncoder [Encode] Too Long Frame ..."];
        }
        return nil;
    }
    
    if (data.length==0) {
        if ( error != NULL ){
            *error = [self createEncodeErrorWithCode:1 message:@"HEProtobufVarint32LengthEncoder 接受的数据为空"];
        }
        return nil;
    }
    
    NSMutableData *sendData = [[NSMutableData alloc] init];
    
    //可变长度编码 将数据长度转换为长度字节，写入到数据块中。这里根据head占的字节个数转换data长度，长度不定[1~5]
    NSUInteger dataLen = data.length;
    NSData *headData = [NSData dataWithRawVarint32:dataLen];
    [sendData appendData:headData];
    [sendData appendData:data];
    
    if(self.next){
        return [self.next encode:sendData error:error];
    }else{
        return sendData;
    }
}
@end
