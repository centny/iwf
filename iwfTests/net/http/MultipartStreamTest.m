//
//  MultipartStreamTest.m
//  iwf
//
//  Created by Centny on 8/27/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <iwf/iwf.h>

@interface MultipartStreamTest : XCTestCase

@end

@implementation MultipartStreamTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMultipartStream {
    XCTAssertTrue([Util writef:@"a.txt" str:@"xxxx"],@"creat file rror");
    XCTAssertTrue([Util writef:@"b.txt" str:@"xxbb"],@"creat file rror");
    long fs_a=[Util fsize:@"a.txt"];
    long fs_b=[Util fsize:@"b.txt"];
    NSString* fp_a=[Util homef:@"a.txt"];
    NSString* fp_b=[Util homef:@"b.txt"];
    MultipartStream* ms=[[MultipartStream alloc]initWithBound:@"$$abc$$"];
    [ms addPis:[[FPis alloc]initWithPath:fp_a name:@"file_a" filename:@"测试a.txt" type:nil length:fs_a]];
    [ms addPis:[[FPis alloc]initWithPath:fp_b name:@"file_b" filename:@"测试b.txt" type:nil length:fs_b]];
    [ms addPis:[[FPis alloc]initWithString:@"测试数据" name:@"xx"]];
    [ms addPis:[[FPis alloc]initWithData:[@"测试数据" dataUsingEncoding:NSUTF8StringEncoding] name:@"yy"]];
    PrintStream(ms);
}

@end
