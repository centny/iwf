//
//  ClassExtTest.m
//  iwf
//
//  Created by Centny on 8/31/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <iwf/iwf.h>

@interface ClassExtTest : XCTestCase

@end

@implementation ClassExtTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJson {
    NSMutableDictionary* dict=[NSMutableDictionary dictionary];
    [dict setObject:@"1" forKey:@"a"];
    [dict setObject:@"这是中文" forKey:@"b"];
    NSData* json=[dict toJson:nil];
    NSDictionary* dict2=[json toJsonObject:nil];
    XCTAssert([@"1" isEqual:[dict2 objectForKey:@"a"]],"a value is error");
    XCTAssert([@"这是中文" isEqual:[dict2 objectForKey:@"b"]],"b value is error");
    XCTAssert(json.length==[dict2 toJson:nil].length,"length is error");
    //
    NSMutableArray* ary=[NSMutableArray array];
    [ary addObject:dict];
    [ary addObject:dict2];
    json=[ary toJson:nil];
    NSArray* ary2=[json toJsonObject:nil];
    dict2=[ary2 objectAtIndex:0];
    XCTAssert(ary.count==ary2.count,"count is error");
    XCTAssert([@"1" isEqual:[dict2 objectForKey:@"a"]],"a value is error");
    XCTAssert([@"这是中文" isEqual:[dict2 objectForKey:@"b"]],"b value is error");
    XCTAssert(json.length==[ary2 toJson:nil].length,"length is error");
}

@end
