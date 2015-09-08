//
//  TablExtXibVCtl.m
//  iwf-test
//
//  Created by Centny on 9/2/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "TableExtXibVCtl.h"
#import <iwf/iwf.h>
#import "TableExtItemView.h"

@interface TablExtXibVCtl ()
@property(nonatomic,assign)NSInteger count;
@end

@implementation TablExtXibVCtl
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.count=20;
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [@"Cell" stringByAppendingFormat:@"-%ld",indexPath.item];
    UITableViewXibCell* cell=[tableView newOrReuseCellWithClass:[TableExtItemView class]];
    TableExtItemView * eiv=cell.xview;
    eiv.text.text=identifier;
    eiv.img.url=[NSString stringWithFormat:@"http://pb.dev.jxzy.com/img/F1%04ld.jpg",indexPath.item];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(BOOL)isNeedRefresh:(UITableExtView *)tableview{
    return YES;
}
-(void)onRefresh:(UITableExtView *)tableview{
    //mock http call back.
    NSDLog(@"%f", FRAM_W(tableview));
    [tableview performSelector:@selector(reloadData) withObject:nil afterDelay:3];
}
-(void)onNextPage:(UITableExtView *)tableview{
    self.count+=20;
    [tableview reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
