//
//  ForTestTextFieldVCtl.m
//  iwf-test
//
//  Created by vty on 9/28/15.
//  Copyright © 2015 Snows. All rights reserved.
//

#import "ForTestTextFieldVCtl.h"

@interface ForTestTextFieldVCtl ()

@end

@implementation ForTestTextFieldVCtl
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.viewLoaded=NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewLoaded=YES:
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clkBtn:(id)sender{
    if([@"a" isEqualToString:self.tf.text]){
        return;
    }
    NSLog(@"%@",self.tf.text);
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
