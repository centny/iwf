//
//  ForTableViewTestVCtlTest.m
//  iwf-test
//
//  Created by Centny on 9/16/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <iwf/iwf.h>
#import "ForTableViewTestVCtl.h"

@interface ForTableViewTestVCtlTest : XCTestCase<NSBoolable>
@property(nonatomic,retain) ForTableViewTestVCtl* vctl;
@property (readonly) BOOL boolValue;
@end

//extern void __gcov_flush();

@implementation ForTableViewTestVCtlTest

- (void)setUp {
    [super setUp];
    [self performSelectorOnMainThread:@selector(load) withObject:nil waitUntilDone:YES];
}

- (void)tearDown {
    [super tearDown];
    self.vctl=nil;
//    __gcov_flush();
}
- (BOOL)boolValue{
    if(self.vctl==nil){
        return false;
    }
    return self.vctl.adata.count>self.vctl.pn*self.vctl.ps;
}
- (void)load{
    self.vctl=[[ForTableViewTestVCtl alloc]initWithNibName:nil bundle:[NSBundle bundleForClass:[ForTableViewTestVCtl class]]];
    UINavigationController* nv=(UINavigationController*)[[[UIApplication sharedApplication]keyWindow]rootViewController];
    [nv pushViewController:self.vctl animated:YES];
}
-(void)refresh{
    XCTAssert([self.vctl isNeedRefresh:self.vctl.tview],@"not neead refresh");
    [self.vctl onRefresh:self.vctl.tview];
}
-(void)next{
    [self.vctl onNextPage:self.vctl.tview];
}
- (void)testLoad {
    //wait first load
    XCTAssert(RunLoopx(self), @"time out");
    //test refresh
    [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:YES];
    XCTAssert(RunLoopx(self), @"time out");
    //test next page
    [self performSelectorOnMainThread:@selector(next) withObject:nil waitUntilDone:YES];
    XCTAssert(RunLoopx(self), @"time out");
    [self.vctl.navigationController popViewControllerAnimated:YES];
}

@end
