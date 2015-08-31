//
//  UITableExtView.h
//  Centny
//
//  Created by Centny on 9/24/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIRefreshViewDelegate.h"
@class UITableExtView;
// the Table view extend delegate.
@protocol UITableExtViewDelegate <UITableViewDelegate>
@optional
// checking if need refresh.
- (BOOL)isNeedRefresh:(UITableExtView *)tableview;
// on refresh.
- (void)onRefresh:(UITableExtView *)tableview;
// on next page calling.
- (void)onNextPage:(UITableExtView *)tableview;
@end
// the extend table view implements next page and refresh header view.
//
@interface UITableExtView : UITableView <UITableViewDelegate>{
}
@property(nonatomic, readonly) UIView						*refreshView;
@property(nonatomic, retain) id <UIRefreshViewDelegate>		rdelegate;
@property(nonatomic, retain) id <UITableExtViewDelegate>	tdelegate;
// the general initial method,it will using the default UIRefreshView as it refresh view.
- (id)initWithFrame:(CGRect)frame;
// the general initial method with using the custom refresh view
// when using this initial method,you change the curstom refresh view's status change by implementing UIRefreshViewDelegate.
- (id)initWithFrame:(CGRect)frame refreshView:(UIView *)refreshView;
// talk the refresh view the refresh action completed.
- (void)refreshCompleted:(void (^)(BOOL))finished;
// reload
- (void)reloadData;
@end