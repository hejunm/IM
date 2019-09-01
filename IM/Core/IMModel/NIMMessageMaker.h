//
//  NIMMessageMaker.h
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NIMMessage.h"
#import "NIMCustomObject.h"

@class NIMKitLocationPoint;

@interface NIMMessageMaker : NSObject

+ (NIMMessage*)msgWithText:(NSString *)text;

+ (NIMMessage *)msgWithImage:(UIImage *)image;

+ (NIMMessage *)msgWithImagePath:(NSString *)path;

+ (NIMMessage *)msgWithAudio:(NSString *)filePath;

+ (NIMMessage *)msgWithVideo:(NSString *)filePath;

+ (NIMMessage *)msgWithFilePath:(NSString *)filePath;

+ (NIMMessage *)msgWithLocation:(NIMKitLocationPoint *)locationPoint;

+ (NIMMessage *)msgWithCustomAttachment:(id<NIMCustomAttachment>)attachment;

@end
