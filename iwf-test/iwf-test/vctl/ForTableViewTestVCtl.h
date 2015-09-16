//
//  ForTableViewTestVCtl.h
//  iwf-test
//
//  Created by Centny on 9/16/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iwf/iwf.h>

@interface ForTableViewTestVCtl : UIViewController<UITableViewDataSource,UITableExtViewDelegate>
@property(nonatomic,assign)IBOutlet UITableExtView* tview;
@property(nonatomic,readonly)int pn;
@property(nonatomic,readonly)int ps;
@property(nonatomic,readonly)NSMutableArray* adata;
@end
