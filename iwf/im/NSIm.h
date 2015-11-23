//
//  NSIm.h
//  iwf
//
//  Created by vty on 11/18/15.
//  Copyright © 2015 Snows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cwf/cwf.h>

#define MK_NIM 0
#define MK_NMR 2
#define MK_NRC 4
#define MK_NRC_LI 10
#define MK_NRC_LO 20
#define MK_NRC_UR 30

@class NSIm,ImMsg;

@protocol NSImH <NSObject>
@required
-(int)onMsg:(NSIm*)im msg:(ImMsg*) msg;
@optional
-(void)onSckEvn:(NSIm*)im evn:(int)evn arga:(void*)arga argb:(void*)argb;
@end

@interface NSIm : NSObject
@property(strong)NSString* ip;
@property(assign)short port;
@property(assign,readonly)v_cwf_im* im;
@property(assign)id<NSImH> delegate;
-(id)initWith:(NSString*)ip port:(short)port;

-(int)run:(int)erc;
-(void)close;
-(NSDictionary*)login:(NSDictionary*)args err:(NSError**)err;
-(NSDictionary*)logout:(NSDictionary*)args err:(NSError**)err;
-(NSDictionary*)ur:(NSDictionary*)args err:(NSError**)err;
-(int)sms:(ImMsg*)msg;
-(int)mr:(NSString*)a mids:(NSString*)mids;
@end
