//
//  HEReqHeader.h
//  IM
//
//  Created by jmhe on 2018/10/24.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HEReqHeader : JSONModel
@property(nonatomic,assign)uint32_t taskId;   //任务id
@end

NS_ASSUME_NONNULL_END
