//
//  HESocketConnection.h
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HESocketConnectParam;

NS_ASSUME_NONNULL_BEGIN

/**
 重连
 心跳
 */

@interface HESocketConnection : NSObject

/**
 根据初始化参数建立tcp链接
 */
- (void)openConnection;

/**
 *  主动断开socket服务器连接
 */
- (void)disconnect;

/**
 *  和socket服务器的连接状态
 *
 *  @return 返回yes－连接，no－断开
 */
- (BOOL)isConnected;

/**
 *  接收数据方法，读取socket中的下行数据流。根据GCDAsyncSocket提供的方法，对外提供参数。
 *  该方法有tag标记，和写socket中的上行数据中的tag对应。如果希望针对某个tag写请求读取对应的返回数据，需要记录tag。
 *
 *  @param timeout 读取数据超时时间
 *  @param tag     读取数据tag标记，和writeData:timeout:tag:中的tag对应。
 */
- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag;

/**
 *  发送数据方法，写socket的上行数据流。根据GCDAsyncSocket提供的方法，对外提供参数。
 *  该方法有tag标记，为了简化使用方式，框架中统一使用0。
 *  发送数据后，一定要调用一次read，这样数据才会及时触发读取。
 *  我在didReadData和didWriteDataWithTag方法中都有加的read的，所以你们可以放心用啦。
 *  [有的朋友说，自己连接上服务器后一直读不到数据，就是因为没有read。]
 *
 *  @param data    待发送的数据块
 *  @param timeout 发送超时时间
 *  @param tag     发送的特定请求标记，和readDataWithTimeout:tag中的tag对应。
 */
- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag;

@end

NS_ASSUME_NONNULL_END
