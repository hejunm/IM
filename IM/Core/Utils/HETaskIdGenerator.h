//
//  HETaskIdGenerator.h
//  IM
//
//  Created by jmhe on 2018/10/24.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HETaskIdGenerator : NSObject
+(instancetype) shareInstance;
- (NSUInteger)createId;
@end
