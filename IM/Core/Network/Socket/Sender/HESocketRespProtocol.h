//
//  HESocketRespProtocol.h
//  IM
//
//  Created by jmhe on 2018/11/2.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#ifndef HESocketRespProtocol_h
#define HESocketRespProtocol_h

@protocol HESocketRespProtocol <NSObject>

+ (id)responseModelWithData:(NSData *)data;

@end

#endif /* HESocketRespProtocol_h */
