//
//  ForTestActionVCtlTest.m
//  iwf-test
//
//  Created by Centny on 9/15/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ForTestActionVCtl.h"
#import <iwf/iwf.h>

@interface ForTestActionVCtlTest : XCTestCase<NSBoolable>
@property(nonatomic,retain) ForTestActionVCtl* vctl;
@property (readonly) BOOL boolValue;
@end

@implementation ForTestActionVCtlTest


- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}

- (void)load{
    self.vctl=[[ForTestActionVCtl alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[ForTestActionVCtl class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    [nv pushViewController:self.vctl animated:YES];
}
- (BOOL)boolValue{
    return [@"values" isEqualToString:self.vctl.lb1.text];
}
- (void)tearDown {
    [super tearDown];
    self.vctl=nil;
}

- (void)testSetValue {
    XCTAssert(RunLoopv(self),@"time out");
    self.vctl.txt1.text=@"val1";
    [self.vctl performSelectorOnMainThread:@selector(clkBtn1:) withObject:self.vctl.btn1 waitUntilDone:YES];
    XCTAssertEqualObjects(self.vctl.txt1.text, @"val1", @"label valus is not equal text field");
    XCTAssertEqualObjects(self.vctl.txt1.text, self.vctl.lb1.text,@"label valus is not equal text field");
}

@end
