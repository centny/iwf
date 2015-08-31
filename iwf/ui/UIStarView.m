//
//  UIStarView.m
//  Centny
//
//  Created by Centny on 7/3/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "UIStarView.h"
#import <Foundation/Foundation.h>
#import "../GeneralDef.h"
@interface UIStarView () {
	NSMutableArray	*_stars;
	UIImageView		*_hstar;
	NSMutableArray	*_backStars;
	UIImage			*_starImg;
	UIImage			*_halfStarImg;
	UIImage			*_backStarImg;
}
@end

@implementation UIStarView
@synthesize starImg = _starImg, halfStarImg = _halfStarImg, backStarImg = _backStarImg;

- (void)setStarImg:(UIImage *)starImg
{
	_starImg = starImg;

	for (UIImageView *iv in _stars) {
		iv.image = _starImg;
	}
}

- (void)setHalfStarImg:(UIImage *)halfStarImg
{
	_halfStarImg	= halfStarImg;
	_hstar.image	= _halfStarImg;
}

- (void)setBackStarImg:(UIImage *)backStarImg
{
	_backStarImg = backStarImg;

	for (UIImageView *iv in _backStars) {
		iv.image = _backStarImg;
	}
}

- (id)init
{
	self = [super init];

	if (self) {
		self.w_h = 0;
	}

	return self;
}

- (id)initWithFrame:(CGRect)frame star:(float)star maxStar:(int)max
{
	self = [super initWithFrame:frame];

	if (self) {
		[self initStar:star maxStar:max];
	}

	return self;
}

- (void)initStar:(float)star maxStar:(int)max
{
	for (UIView *v in self.subviews) {
		if ([v isKindOfClass:[UIImageView class]]) {
			[v removeFromSuperview];
		}
	}

	int value	= star * 10;
	int ss		= value / 10;

	ss = ss < max ? ss : max;
	int			hs = (value % 10) / 5;
	UIImageView *iv;
	GLfloat		size	= self.frame.size.height;
	GLfloat		width	= self.w_h + size;
	int			point	= 0;
	_stars = [[NSMutableArray alloc] init];

	for (int i = 0; i < ss; i++, point++) {
		iv			= [[UIImageView alloc] initWithFrame:CGRectMake(point * (width + SV_STAR_DIS), 0, width, size)];
		iv.image	= self.starImg;
		[self addSubview:iv];
		[_stars addObject:iv];
	}

	if ((ss < max) && hs && self.halfStarImg) {
		iv = [[UIImageView alloc] initWithFrame:CGRectMake(point * (width + SV_STAR_DIS), 0, width, size)];
		iv.backgroundColor	= [UIColor clearColor];
		iv.image			= self.backStarImg;
		[self addSubview:iv];
		[_backStars addObject:iv];
		iv			= [[UIImageView alloc] initWithFrame:CGRectMake(point * (width + SV_STAR_DIS), 0, width, size)];
		iv.image	= self.halfStarImg;
		[self addSubview:iv];
		_hstar = iv;
		point++;
	}

	int grays = max - point;
	_backStars = [[NSMutableArray alloc] init];

	for (int i = 0; i < grays; i++, point++) {
		iv			= [[UIImageView alloc] initWithFrame:CGRectMake(point * (width + SV_STAR_DIS), 0, width, size)];
		iv.image	= self.backStarImg;
		[self addSubview:iv];
		[_backStars addObject:iv];
	}
}

@end
