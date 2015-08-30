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
#import <iwf/iwf-Swift.h>

@interface MultipartBuilderTest : XCTestCase

@end

@implementation MultipartBuilderTest

- (void)testMultipartBuilder {
    XCTAssertTrue([Util writef_:@"a.txt" str:@"xxxx"],@"creat file rror");
    NSString* fp_a=[Util homef:@"a.txt"];
    MultipartBuilder *mb=[[MultipartBuilder alloc]initWithBound:@"^*^" args:nil name:@"file" path:fp_a];
    [mb addArgs:[NSDictionary dictionaryBy:@"a=1&b=12" arySeparator:@"&" kvSeparator:@"="]];
//    MultipartStream* ms=[[MultipartStream alloc]initWithBound:@"$$abc$$"];
//    [ms addPis:[[FPis alloc]initWithPath:fp_a name:@"file_a" filename:@"测试a.txt" type:nil length:fs_a]];
//    [ms addPis:[[FPis alloc]initWithPath:fp_b name:@"file_b" filename:@"测试b.txt" type:nil length:fs_b]];
//    [ms addPis:[[FPis alloc]initWithString:@"测试数据" name:@"xx"]];
//    [ms addPis:[[FPis alloc]initWithData:[@"测试数据" dataUsingEncoding:NSUTF8StringEncoding] name:@"yy"]];
    PrintStream([mb build]);
}

@end
