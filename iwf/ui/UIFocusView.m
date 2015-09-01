//
//  UIFocusImageView.m
//  FFS_Framework
//
//  Created by ShaoHong Wen on 7/6/12.
//  Copyright (c) 2012 fengfeng. All rights reserved.
//

#import "UIFocusView.h"
#import <iwf/iwf.h>
#import <Foundation/Foundation.h>

@interface UIFocusView ()

@end
//
@implementation UIFocusView
@synthesize currentPage				= _currentPage, pageIdx = _pageIdx;
@synthesize limitScroll				= _limitScroll;
@synthesize scroll, page, delegate	= _delegate;
//
- (void)updatePage
{
	page.currentPage = _currentPage;
	[page updateCurrentPageDisplay];
	scroll.contentOffset = CGPointMake(_pageIdx * ssize.width, 0);
}

- (void)setLimitScroll:(BOOL)limitScroll
{
	_limitScroll = limitScroll;

	if (_limitScroll) {
		page.numberOfPages = [_subviews count];
	} else {
		page.numberOfPages = [_subviews count] - 2;
	}

	[self setCurrentPage:_currentPage];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
	if ((currentPage < 0) || (currentPage >= [_subviews count])) {
		return;
	}

	if (_limitScroll) {
		_pageIdx = currentPage;
	} else {
		if (currentPage >= [_subviews count]) {
			return;
		}

		_pageIdx = currentPage + 1;
	}

	_currentPage = currentPage;
	[self updatePage];
}

- (void)setPageIdx:(NSInteger)pageIdx
{
	if ((pageIdx < 0) || (pageIdx >= [_subviews count])) {
		return;
	}

	if (_limitScroll) {
		_currentPage	= pageIdx;
		_pageIdx		= pageIdx;
	} else {
		if (pageIdx == ([_subviews count] - 1)) {
			_currentPage	= 0;
			_pageIdx		= _currentPage + 1;
		} else if (0 == pageIdx) {
			_currentPage	= [_subviews count] - 3;
			_pageIdx		= _currentPage + 1;
		} else {
			_currentPage	= pageIdx - 1;
			_pageIdx		= pageIdx;
		}
	}

	[self updatePage];
}

-(void)setAutoplay:(int)autoplay{
    _autoplay=autoplay;
    if(autoplay>0){
        [self performSelector:@selector(autoPlayNext) withObject:nil afterDelay:self.autoplay];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	self.pageIdx = scroll.contentOffset.x / ssize.width;

	if (_delegate&& [_delegate respondsToSelector:@selector(onDidScroll:idx:)]) {
        [_delegate onDidScroll:self idx:self.pageIdx];
	}
}

- (void)initPage:(UIPageControl *)_page views:(NSArray *)views
{
    if(!_page){
        page=[[UIPageControl alloc]initWithFrame:CGRectMake(0, FRAM_H(self)-18, FRAM_W(self), FV_PAGEC_H)];
    }
    if(!views){
        return;
    }
	_subviews = views;
	UIView *sview = [views objectAtIndex:0];
	ssize	= sview.frame.size;
	scroll	= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	scroll.clipsToBounds	= NO;
	scroll.pagingEnabled	= YES;
	int vcount = (int)[views count];
	scroll.contentSize = CGSizeMake(ssize.width * ([views count]), 0);
	scroll.showsHorizontalScrollIndicator = NO;
	scroll.delegate = self;

	for (int i = 0; i < vcount; i++) {
		UIView *v = [views objectAtIndex:i];
		v.frame = CGRectMake(i * ssize.width, 0, ssize.width, ssize.height);
		[scroll addSubview:v];
	}

	[self addSubview:scroll];
	//
	page = _page;
	page.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	page.userInteractionEnabled		= NO;
	page.hidesForSinglePage			= YES;
	[self addSubview:page];
	self.clipsToBounds	= YES;
	self.limitScroll	= self.limitScroll;//for setting page number.
	self.currentPage	= 0;
    [self addGestureRecognizer:[UIGestureRecognizer recognizerByClick:self action:@selector(onClk)]];
}
- (void)showViews:(NSArray*)views{
    [self initPage:self.page views:views];
}
- (void)showUrls:(NSArray*)urls loading:(NSString*)loading{
    NSArray *ary=[self MakeImgView:CGRectMake(0, 0, FRAM_W(self), FRAM_H(self)) urls:urls loading:loading];
    [self initPage:self.page views:ary];
}
- (id)initWithCoder:(NSCoder *)aDecoder;{
    self = [super initWithCoder:aDecoder];
    if (self) {
        page=[[UIPageControl alloc]initWithFrame:CGRectMake(0, FRAM_H(self)-18, FRAM_W(self), FV_PAGEC_H)];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        page=[[UIPageControl alloc]initWithFrame:CGRectMake(0, FRAM_H(self)-18, FRAM_W(self), FV_PAGEC_H)];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame pc:(UIPageControl *)pc views:(NSArray *)views
{
	self = [super initWithFrame:frame];

	if (self) {
		[self initPage:pc views:views];
	}

	return self;
}
- (id)initWithFrame:(CGRect)frame pc:(UIPageControl *)pc urls:(NSArray *)urls loading:(NSString*)loading{
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray* views=[self MakeImgView:CGRectMake(0, 0, frame.size.width, frame.size.height) urls:urls loading:loading];
        [self initPage:pc views:views];
    }
    return self;
}
- (void)autoPlayNext{
    if(self.autoplay>0){
        [self scrollNext];
        [self performSelector:@selector(autoPlayNext) withObject:nil afterDelay:self.autoplay];
    }
}
- (void)scrollNext
{
	[UIView animateWithDuration:0.4 animations:^{
		scroll.contentOffset = CGPointMake(scroll.contentOffset.x + ssize.width, 0);
	} completion:^(BOOL finished) {
		[self scrollViewDidEndDecelerating:nil];
	}];
}
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath{
    if([KP_FV_PC_HIGHTED isEqualToString:keyPath]){
        self.page.currentPageIndicatorTintColor=value;
        return;
    }else if([KP_FV_PC_NORMAL isEqualToString:keyPath]){
        self.page.pageIndicatorTintColor=value;
        return;
    }else if([KP_FV_PC_FRAME isEqualToString:keyPath]){
        self.page.frame=[value CGRectValue];
        return;
    }else if([KP_FV_PC_AUTOPLAY isEqualToString:keyPath]){
        self.autoplay=[value intValue];
    }
    [super setValue:value forKey:keyPath];
}
- (void)onClk{
    if(_delegate&&[_delegate respondsToSelector:@selector(onClick:idx:)]){
        [_delegate onClick:self idx:self.pageIdx];
    }
}

- (NSArray*)MakeImgView:(CGRect)frame urls:(NSArray*) urls loading:(NSString*)loading{
    NSMutableArray* ary=[NSMutableArray array];
    UIImageView *iv;
    iv=[[UIImageView alloc]initWithFrame:frame];
    iv.image=[UIImage imageNamed:loading];
    iv.url=[urls objectAtIndex:urls.count-1];
    [ary addObject:iv];
    for (NSString* url in urls) {
        iv=[[UIImageView alloc]initWithFrame:frame];
        iv.image=[UIImage imageNamed:loading];
        iv.url=url;
        [ary addObject:iv];
    }
    iv=[[UIImageView alloc]initWithFrame:frame];
    iv.image=[UIImage imageNamed:loading];
    iv.url=[urls objectAtIndex:0];
    [ary addObject:iv];
    return ary;
}
+ (id)focusView:(CGRect)frame views:(NSArray*)views{
    UIFocusView *fv = [[UIFocusView alloc]initWithFrame:frame];
    [fv showViews:views];
    return fv;
}
+ (id)focusView:(CGRect)frame urls:(NSArray*)urls loading:(NSString*)loading{
    UIFocusView *fv = [[UIFocusView alloc]initWithFrame:frame];
    [fv showUrls:urls loading:loading];
    return fv;
}
@end
