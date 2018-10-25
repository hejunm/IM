//
//  HEDataFormatter.m
//  IM
//
//  Created by jmhe on 2018/10/25.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HEDataFormatter.h"

@implementation HEDataFormatter

+ (uint32_t)integer4FromData:(NSData *)data {
    char *dataChar = (char *)data.bytes;
    char *index = (char *)&dataChar;
    char typeChar[4] = {0};
    for (int i = 0 ; i < data.length; i++) {
        typeChar[4 - 1 - i] = dataChar[i];
        index ++;
    }
    uint32_t integer;
    NSData *typeData = [NSData dataWithBytes:typeChar length:4];
    [typeData getBytes:&integer length:4];
    return integer;
}

+ (NSData *)dataFromInteger4:(uint32_t)integer {

    uint32_t time = integer;
    char *p_time = (char *)&time;
    static char str_time[4] = {0};
    for(int i = 4 - 1; i >= 0; i--) {
        str_time[i] = *p_time;
        p_time ++;
    }
    return [NSData dataWithBytes:&str_time length:4];
}

@end
