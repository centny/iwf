//
//  ForTableViewTestVCtl.m
//  iwf-test
//
//  Created by Centny on 9/16/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "ForTableViewTestVCtl.h"
#import "TableExtItemView.h"
#import "Var.h"

@interface ForTableViewTestVCtl ()
@end

@implementation ForTableViewTestVCtl
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        _adata=[NSMutableArray array];
        _pn=0;
        _ps=20;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _pn=0;
    [self loadData];
}

- (void)loadData{
    [H doGetj:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
        if(err!=nil){
            NSELog(@"request err:%@",err);
            return;
        }
        if([[json objectForKey:@"code"]intValue]==0){
            [self.adata addObjectsFromArray:[json objectForKey:@"data"]];
            [self.tview reloadData];
        }else{
            NSELog(@"request err:%@", json);
        }
    } url:@"%@/page_j?pn=%d&ps=%d",TS_SRV,self.pn,self.ps];
}
- (BOOL)isNeedRefresh:(UITableExtView *)tableview{
    return YES;
}
// on refresh.
- (void)onRefresh:(UITableExtView *)tableview{
    [self.adata removeAllObjects];
    _pn=0;
    [self loadData];
}
// on next page calling.
- (void)onNextPage:(UITableExtView *)tableview{
    _pn++;
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.adata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewXibCell* cell=[tableView newOrReuseCellWithClass:[TableExtItemView class]];
    TableExtItemView * eiv=cell.xview;
    NSDictionary* data=[self.adata objectAtIndex:indexPath.item];
    eiv.img.url=[data objectForKey:@"url"];
    eiv.text.text=[data objectForKey:@"name"];
    return cell;
}
@end
