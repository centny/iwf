//
//  TableExtVCtl.m
//  Centny
//
//  Created by Centny on 9/24/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "TableExtVCtl.h"
#import "TableExtItemView.h"
#import <iwf/iwf.h>
@interface TableExtVCtl ()
@property(nonatomic,assign)NSInteger count;
@end

@implementation TableExtVCtl
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewXibCell* cell=[tableView newOrReuseCellWithClass:[TableExtItemView class]];
    TableExtItemView * eiv=cell.xview;
    eiv.text.text=[@"Cell" stringByAppendingFormat:@"-%ld",indexPath.item];
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
    [tableview performSelector:@selector(reloadData) withObject:nil afterDelay:3];
}
-(void)onNextPage:(UITableExtView *)tableview{
    self.count+=20;
    [tableview reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets=NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.count=20;
    UITableExtView *tev=[[UITableExtView alloc]initWithFrame:CGRectMake(0, 50, FRAM_W(self.view), FRAM_H(self.view))];
    tev.backgroundColor=[UIColor redColor];
    tev.tdelegate=self;
    tev.dataSource=self;
    [self.view addSubview:tev];
}

@end
