//
//  FocusViewVCtl.m
//  iwf-test
//
//  Created by Centny on 9/1/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "FocusViewVCtl.h"

@interface FocusViewVCtl ()

@end

@implementation FocusViewVCtl
- (void)onDidScroll:(UIFocusView*)focus idx:(NSInteger)idx{
    NSDLog(@"on scroll:%ld", idx);
}
- (void)onClick:(UIFocusView*)focus idx:(NSInteger)idx{
    NSDLog(@"on click:%ld", idx);
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.fiv.limitScroll=NO;
    [self.fiv showUrls:[NSArray arrayWithObjects:@"http://pb.dev.jxzy.com/img/F10000.jpg",@"http://pb.dev.jxzy.com/img/F10001.jpg",@"http://pb.dev.jxzy.com/img/F10002.jpg", nil] loading:@"star"];
    
    UIFocusView *fv=[UIFocusView focusView:CGRectMake(0, 400, FRAM_W(self.view), 213) urls:[NSArray arrayWithObjects:@"http://pb.dev.jxzy.com/img/F10100.jpg",@"http://pb.dev.jxzy.com/img/F10101.jpg",@"http://pb.dev.jxzy.com/img/F10102.jpg", nil] loading:@"star"];
    fv.page.currentPageIndicatorTintColor=[UIColor greenColor];
    fv.page.pageIndicatorTintColor=[UIColor whiteColor];
    fv.delegate=self;
    //setting auto play delay to 5s.
//    fv.autoplay=5;
    [self.view addSubview:fv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
