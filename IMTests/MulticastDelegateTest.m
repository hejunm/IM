//
//  MulticastDelegateTest.m
//  IMTests
//
//  Created by wulixiwa on 2018/10/20.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HEMulticastDelegate.h"

@protocol HETestDelegate <NSObject>
- (void)method1;
- (void)method2:(NSString *)pro1;
- (void)method3;
@end

@interface HETestDelegateImp1:NSObject<HETestDelegate>

@end

@implementation HETestDelegateImp1

- (void)method1{
    NSLog(@"HETestDelegateImp1 method1");
}
- (void)method2:(NSString *)pro1{
    NSLog(@"HETestDelegateImp1 method2 %@",pro1);
}
@end

@interface HETestDelegateImp2:NSObject<HETestDelegate>

@end

@implementation HETestDelegateImp2
- (void)method1{
    NSLog(@"HETestDelegateImp2 method1");
}
- (void)method2:(NSString *)pro1{
    NSLog(@"HETestDelegateImp2 method2 %@",pro1);
}
@end

@interface MulticastDelegateTest : XCTestCase

@end

@implementation MulticastDelegateTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    HEMulticastDelegate<HETestDelegate> *mulDelegate = [[HEMulticastDelegate alloc]init];
    HETestDelegateImp1 *imp1 = [[HETestDelegateImp1 alloc]init];
    [mulDelegate addDelegate:imp1 delegateQueue:dispatch_get_main_queue()];
    
    HETestDelegateImp2 *imp2 = [[HETestDelegateImp2 alloc]init];
    [mulDelegate addDelegate:imp2 delegateQueue:dispatch_get_main_queue()];
    
    [mulDelegate removeDelegate:imp2];

    [mulDelegate method1];
    [mulDelegate method2:@"hello"];
    [mulDelegate method3];
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
