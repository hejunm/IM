//
//  IMTests.m
//  IMTests
//
//  Created by jmhe on 2018/10/16.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MD5Tool.h"

@interface IMTests : XCTestCase

@end

@implementation IMTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testMD5Tool{
    XCTAssertEqualObjects(@"5EB63BBBE01EEED093CB22BB8F5ACDC3", [MD5Tool md5OfStr:@"hello world"], @"不相等");
    
    NSString *imageFilepath =  [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    XCTAssertEqualObjects(@"B3C8622CC85A5783B6B39E6C998F8C1E", [MD5Tool md5OfFile:imageFilepath], @"不相等");
    
    NSData *imageData = [NSData dataWithContentsOfFile:imageFilepath];
    XCTAssertEqualObjects(@"B3C8622CC85A5783B6B39E6C998F8C1E", [MD5Tool md5OfData:imageData], @"不相等");
    
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
