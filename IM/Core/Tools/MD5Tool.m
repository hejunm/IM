//
//  MD5Tool.m
//  IM
//
//  Created by jmhe on 2018/10/16.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "MD5Tool.h"
#include <CommonCrypto/CommonDigest.h>

@implementation MD5Tool

+ (NSString *)md5ForData:(NSData *)data{
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *ms = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat: @"%02X", (int)(digest[i])];
    }
    return [ms copy];
}

+ (NSString *)md5ForStr:(NSString *)string{
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5([string UTF8String], (unsigned int)strlen([string UTF8String]), digest);
    NSMutableString *ms = [NSMutableString string];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [ms appendFormat:@"%02X",(int)digest[i]];
    }
    return ms;
}

+ (NSString *)md5ForFile:(NSString *)filePath{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if( handle== nil ) {
        return nil; // file didnt exist
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done){
        NSData* fileData = [handle readDataOfLength:1024*8];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if( [fileData length] == 0 ) {
            done = YES;
        }
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSMutableString *ms = [NSMutableString string];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [ms appendFormat:@"%02X",(int)digest[i]];
    }
    return ms;
}
@end
