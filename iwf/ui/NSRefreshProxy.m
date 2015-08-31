//
//  NSRefreshProxy.m
//  Centny
//
//  Created by Centny on 9/24/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "NSRefreshProxy.h"
#import "UIRefreshViewDelegate.h"
#import <iwf/iwf.h>
@implementation NSRefreshProxy
@synthesize refreshDragDis		= _refreshDragDis;
@synthesize refreshBeginPoint	= _refreshBeginPoint, refreshDirection = _refreshDirection;
//
- (BOOL)effectDrag:(UIScrollView *)scrollView
{
    BOOL effected = NO;
    
    switch (_refreshDirection) {
        case DD_UP:
            effected = (scrollView.contentOffset.y - _refreshBeginPoint.y) > _refreshDragDis;
            break;
            
        case DD_DOWN:
            effected = (_refreshBeginPoint.y - scrollView.contentOffset.y) > _refreshDragDis;
            break;
            
        case DD_LEFT:
            effected = (scrollView.contentOffset.x - _refreshBeginPoint.x) > _refreshDragDis;
            break;
            
        case DD_RIGHT:
            effected = (_refreshBeginPoint.x - scrollView.contentOffset.x) > _refreshDragDis;
            break;
            
        default:
            effected = NO;
            break;
    }
    return effected;
}

- (BOOL)effectDidRefresh:(UIScrollView *)scrollView
{
    BOOL effected = NO;
    
    switch (_refreshDirection) {
        case DD_UP:
            effected = (scrollView.contentOffset.y - _refreshBeginPoint.y) == 0;
            break;
            
        case DD_DOWN:
            effected = (_refreshBeginPoint.y - scrollView.contentOffset.y) == 0;
            break;
            
        case DD_LEFT:
            effected = (scrollView.contentOffset.x - _refreshBeginPoint.x) == 0;
            break;
            
        case DD_RIGHT:
            effected = (_refreshBeginPoint.x - scrollView.contentOffset.x) == 0;
            break;
            
        default:
            effected = NO;
            break;
    }
    return effected;
}

- (UIEdgeInsets)insetByRefreshing:(UIEdgeInsets)ninset refreshing:(BOOL)refreshing
{
    float rate = refreshing ? 1 : -1;
    
    switch (_refreshDirection) {
        case DD_UP:
            ninset.bottom += rate * (_refreshDragDis);
            break;
            
        case DD_DOWN:
            ninset.top += rate * (_refreshDragDis);
            break;
            
        case DD_LEFT:
            ninset.right -= rate * (_refreshDragDis);
            break;
            
        case DD_RIGHT:
            ninset.left += rate * (_refreshDragDis);
            break;
            
        default:
            break;
    }
    return ninset;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _refreshBeginPoint	= CGPointMake(0, 0);
        _refreshDirection	= DD_DOWN;
    }
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self effectDrag:scrollView]) {
        if ([_rdelegate respondsToSelector:@selector(onCanRelHand:)]) {
            [_rdelegate onCanRelHand:scrollView];
        }
    }
    
    if ([self effectDidRefresh:scrollView]) {
        if ([_rdelegate respondsToSelector:@selector(onDidRefresh:)]) {
            [_rdelegate onDidRefresh:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView isNeedRefresh:(BOOL (^)(void))isNeedRefresh onRefresh:(void (^)(void))onRefresh
{
    if ([self effectDrag:scrollView]&&!self.refreshing) {
        //
        if (!isNeedRefresh || !isNeedRefresh()) {
            return;
        }
        self.refreshing=YES;
        [UIView animateWithDuration:0.5 animations:^{
            scrollView.contentInset = [self insetByRefreshing:scrollView.contentInset refreshing:YES];
        } completion:^(BOOL finished) {
            if ([_rdelegate respondsToSelector:@selector(onRelHandle:)]) {
                [_rdelegate onRelHandle:scrollView];
            }
            
            onRefresh();
        }];
    }
}

- (void)refreshCompleted:(UIScrollView *)scrollView finished:(void (^)(BOOL))finished
{
    if(!self.refreshing){
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        scrollView.contentInset = [self insetByRefreshing:scrollView.contentInset refreshing:NO];
    } completion:^(BOOL f) {
        self.refreshing=NO;
        if(finished){
            finished(f);
        }
    }];
}

@end
