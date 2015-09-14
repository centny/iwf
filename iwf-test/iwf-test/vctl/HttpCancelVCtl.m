//
//  HttpCancelVCtl.m
//  iwf-test
//
//  Created by Centny on 9/8/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "HttpCancelVCtl.h"
#import <iwf/iwf.h>

@interface HttpCancelVCtl ()

@end

@implementation HttpCancelVCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [H doGet:^(URLRequester *req, NSData *data, NSError *err) {
        NSDLog(@"%@",[data UTF8String]);
        [self show];
    } url:@"http://localhost:8000/sleep?time=%d",5000];
    // Do any additional setup after loading the view.
}
- (void)show{
    NSDLog(@"%@", @"showing->");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    NSDLog(@"%@", @"dealloc");
}
@end
