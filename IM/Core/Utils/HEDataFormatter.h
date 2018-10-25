//
//  HEDataFormatter.h
//  IM
//
//  Created by jmhe on 2018/10/25.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HEDataFormatter : NSObject
+ (uint32_t)integer4FromData:(NSData *)data;
+ (NSData *)dataFromInteger4:(uint32_t)integer;
@end
