//
//  NIMMessage.m
//  IM
//
//  Created by jmhe on 2018/10/16.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "NIMMessage.h"

@interface NIMMessage()
@end

@implementation NIMMessage

- (NIMMessageType)messageType{
    if (self.messageObject == nil) {
        return NIMMessageTypeText;
    }else{
        return [self.messageObject type];
    }
}

//messageId如何生成？


@end
