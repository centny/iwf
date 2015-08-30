//
//  iwfocTest.m
//  iwf
//
//  Created by Centny on 8/28/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface iwfocTest : XCTestCase

@end

@implementation iwfocTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPath {
    // This is an example of a functional test case.
    NSLog(@"%@",[@"/a/bc/t.txt" stringByDeletingLastPathComponent]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
