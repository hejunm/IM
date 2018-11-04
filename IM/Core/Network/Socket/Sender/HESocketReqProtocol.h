//
//  HESocketReqProtocol.h
//  IM
//
//  Created by jmhe on 2018/11/2.
//  Copyright © 2018 贺俊孟. All rights reserved.
//  socket请求类需要遵守的协议

#ifndef HESocketReqProtocol_h
#define HESocketReqProtocol_h

@protocol HESocketReqProtocol <NSObject>
@required
- (uint32_t)apiCode;
- (void)setTaskId:(uint32_t)taskId;
- (uint32_t)taskId;
- (NSData *)serializeToData;
- (NSString *)responseClassName;
@end

#endif /* HESocketReqProtocol_h */
