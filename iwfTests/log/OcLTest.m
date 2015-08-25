//
//  OcLTest.m
//  iwf
//
//  Created by Centny on 8/25/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <iwf/iwf.h>

@interface OcLTest : XCTestCase

@end

@implementation OcLTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOcl {
    NSDLog(@"debug->%@", @"D");
    NSILog(@"info->%@", @"I");
    NSWLog(@"warn->%@", @"W");
    NSELog(@"error->%@", @"E");
    SetLongf(true);
    SetLevel(LOG_W);
    NSDLog(@"debug->%@", @"D");
    NSILog(@"info->%@", @"I");
    NSWLog(@"warn->%@", @"W");
    NSELog(@"error->%@", @"E");
}

- (void)testPerformanceOcl {
    // This is an example of a performance test case.
    [self measureBlock:^{
        for(int i=0;i<100;i++){
            NSDLog(@"debug->%@->%d", @"D",i);
        }
    }];
}

@end
