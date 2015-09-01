////
////  UICustomPageControl.m
////  FFS_Framework
////
////  Created by ShaoHong Wen on 7/2/12.
////  Copyright (c) 2012 fengfeng. All rights reserved.
////
//
//#import "UIImgPageControl.h"
//#import <iwf/iwf.h>
//@implementation UIImgPageControl {
//}
//- (void)setNormal:(UIImage *)normal{
//    _normal=normal;
////    [self updateCurrentPageDisplay];
//}
//- (void)setLighted:(UIImage *)lighted{
//    _lighted=lighted;
////    [self updateCurrentPageDisplay];
//}
//- (id)initWithFrame:(CGRect)frame{
//    self.backgroundColor=[UIColor clearColor];
//    self= [super initWithFrame:frame];
//    return self;
//}
//- (void)setNumberOfPages:(NSInteger)numberOfPages{
//    [super setNumberOfPages:numberOfPages];
//        for ( UIView *view in self.subviews ) [view removeFromSuperview];
//}
//- (id)initWithFrame:(CGRect)frame normal:(UIImage*)normal lighted:(UIImage*)lighted
//{
//    if (self = [super initWithFrame:frame]) {
//            self.backgroundColor=[UIColor clearColor];
//        self.normal=normal;
//        self.lighted=lighted;
//    }
//    return self;
//}
//
//- (void)updateCurrentPageDisplay
//{
////    for ( UIView *view in self.subviews ) [view removeFromSuperview];
//    [self setNeedsDisplay];
//}
//- (void) awakeFromNib {
//    // retain original subviews in case apple's implementation
//    // relies on the retain count being maintained by the view's
//    // presence in its superview.
////    originalSubviews = [[NSArray alloc] initWithArray: self.subviews];
//    
//
//    
//    // make sure the view is redrawn not scaled when the device is rotated
//    self.contentMode = UIViewContentModeRedraw;
//}
//- (void)drawRect:(CGRect)iRect{
//    int i;
//    CGRect rect;
//    UIImage *image;
//    
//    iRect = self.bounds;
//    if (self.opaque) {
//        [self.backgroundColor set];
//        UIRectFill(iRect);
//    }
//    UIImage *_activeImage = self.lighted;
//    UIImage *_inactiveImage = self.normal;
//    CGFloat _kSpacing = 5.0f;
//    
//    if (self.hidesForSinglePage && self.numberOfPages == 1) {
//        return;
//    }
//    
//    rect.size.height = _activeImage.size.height;
//    rect.size.width = self.numberOfPages * _activeImage.size.width + (self.numberOfPages - 1) * _kSpacing;
//    rect.origin.x = floorf((iRect.size.width - rect.size.width) / 2.0);
//    rect.origin.y = floorf((iRect.size.height - rect.size.height) / 2.0);
//    rect.size.width = _activeImage.size.width;
//    
//    for (i = 0; i < self.numberOfPages; ++i) {
//        image = (i == self.currentPage) ? _activeImage : _inactiveImage;
//        [image drawInRect:rect];
//        rect.origin.x += _activeImage.size.width + _kSpacing;
//    }
//}
//@end
