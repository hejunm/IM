//
//  HETCPTask.h
//  IM
//
//  Created by wulixiwa on 2018/10/24.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HETCPRequestEntity.h"
#import "HETCPResponseEntity.h"

@interface HETCPTask : NSObject

/**req*/
@property(nonatomic,strong)HETCPRequestEntity *request;

/**成功后的回调*/
@property (nonatomic, copy) void (^successBlock)(HETCPResponseEntity *respData);

/**失败后回调*/
@property (nonatomic, copy) void (^failureBlock)(NSError *error);

@end
