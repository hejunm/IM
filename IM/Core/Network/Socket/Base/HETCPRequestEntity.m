//
//  HETCPRequestEntity.m
//  IM
//
//  Created by jmhe on 2018/10/18.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HETCPRequestEntity.h"
#import "HEDataFormatter.h"

@implementation HETCPRequestEntity

- (NSData *)packData{
    NSMutableData *formattedData = [[NSMutableData alloc]init];
    
    //apiCode
    [formattedData appendData:[HEDataFormatter dataFromInteger4:self.apiCode]];
    
    //reqId
    [formattedData appendData:[HEDataFormatter dataFromInteger4:self.reqId]];
    
    //ackId
    [formattedData appendData:[HEDataFormatter dataFromInteger4:self.ackId]];
    
    //contentLength
    [formattedData appendData:[HEDataFormatter dataFromInteger4:(uint32_t)self.contentData.length]];
    
    //content
    [formattedData appendData:self.contentData];
    
    return formattedData;
}
@end
