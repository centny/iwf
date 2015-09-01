//
//  UIFocusImageView.h
//  FFS_Framework
//
//  Created by ShaoHong Wen on 7/6/12.
//  Copyright (c) 2012 fengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KP_FV_PC_NORMAL @"PC_NORMAL" //page control normal image.
#define KP_FV_PC_HIGHTED @"PC_HIGHTED" //page control highted image.
#define KP_FV_PC_AUTOPLAY @"PC_AUTOPLAY" //page control autoplay delay
#define KP_FV_PC_FRAME @"PC_FRAME" //page control frame.
#define FV_PAGEC_H 15
//
@class UIFocusView;

@protocol UIFocusViewDelegate <NSObject>
@optional
- (void)onDidScroll:(UIFocusView*)focus idx:(NSInteger)idx;
- (void)onClick:(UIFocusView*)focus idx:(NSInteger)idx;
@end
@interface UIFocusView : UIView <UIScrollViewDelegate>{
	NSInteger						_currentPage;
	BOOL							_limitScroll;
	NSArray							*_subviews;
	UIScrollView					*scroll;
	UIPageControl					*page;
	CGSize							ssize;
	NSInteger						_pageIdx;
}
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame pc:(UIPageControl *)pc views:(NSArray *)views;
- (id)initWithFrame:(CGRect)frame pc:(UIPageControl *)pc urls:(NSArray *)urls loading:(NSString*)loading;
@property(nonatomic, assign, setter = setCurrentPage:) NSInteger	currentPage;
@property(nonatomic, assign, setter = setPageIdx:) NSInteger		pageIdx;
@property(nonatomic, assign) BOOL									limitScroll;
@property(nonatomic, readonly) UIScrollView							*scroll;
@property(nonatomic, readonly) UIPageControl						*page;
@property(nonatomic, assign) IBOutlet id <UIFocusViewDelegate>      delegate;
@property(nonatomic, assign) int                                    autoplay;
- (void)scrollNext;
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath;
- (void)showViews:(NSArray*)views;
- (void)showUrls:(NSArray*)urls loading:(NSString*)loading;
//
+ (id)focusView:(CGRect)frame views:(NSArray*)views;
+ (id)focusView:(CGRect)frame urls:(NSArray*)urls loading:(NSString*)loading;
@end
