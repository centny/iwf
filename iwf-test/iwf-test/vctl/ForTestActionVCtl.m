//
//  ForTestActionVCtl.m
//  iwf-test
//
//  Created by Centny on 9/15/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "ForTestActionVCtl.h"

@interface ForTestActionVCtl ()

@end

@implementation ForTestActionVCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lb1.text=@"values";
}
-(IBAction)clkBtn1:(id)sender{
    self.lb1.text=self.txt1.text;
}

@end
