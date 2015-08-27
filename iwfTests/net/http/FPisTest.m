//
//  FPisTest.m
//  iwf
//
//  Created by Centny on 8/27/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
#import <iwf/iwf-Swift.h>

@interface FPisTest : XCTestCase

@end

@implementation FPisTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFPis {
    XCTAssertTrue([Util writef:@"t.txt" str:@"xxxx"],@"creat file rror");
    long fs=[Util fsize:@"t.txt"];
    FPis *pis=[[FPis alloc]initWithPath:[Util homef:@"t.txt"] name:@"file" filename:@"测试文件.txt" type:@"plain/text" length:fs];
    PrintStream(pis);
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
