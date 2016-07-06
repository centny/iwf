//
//  NSIm.m
//  iwf
//
//  Created by vty on 11/18/15.
//  Copyright © 2015 Snows. All rights reserved.
//

#import <iwf/iwf.h>

typedef void (^ NSIMRunner)();



int NSIm_on_cmd_nim_(v_cwf_im* im, v_cwf_netw_cmd* cmd) {
    ImMsg* msg=[ImMsg parseFromData:[NSData dataWithBytes:(cmd->hb+cmd->off) length:cmd->len]];
    if(msg==nil){
        NSELog(@"NSIm parse data to ImMsg fail with data(%d)",cmd->len);
        return -1;
    }
    NSIm* tim=(__bridge NSIm *)(im->info);
    if(tim.delegate){
//        [tim performSelectorOnMainThread:@selector(runMain:) withObject:^(){
        [tim.delegate onMsg:tim msg:msg];
//        }waitUntilDone:NO];
    }else{
        NSWLog(@"NSIm is not having delegate to handle msg(%@->%@)",msg.s,[msg.c UTF8String]);
    }
    return 0;
}

void NSIm_on_cmd_nim_sck_evn_h(v_cwf_netw_sck_c* sck, int evn, void* arga,
                             void* argb){
    v_cwf_im* im=sck->info;
    NSIm* tim=(__bridge NSIm *)(im->info);
    if(tim.delegate&&[tim.delegate respondsToSelector:@selector(onSckEvn:evn:arga:argb:)]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [tim.delegate onSckEvn:tim evn:evn arga:arga argb:argb];
        });
    }
}

@implementation NSIm

-(id)initWith:(NSString*)host addr:(NSString*)addr port:(short)port{
    if(self=[super init]){
        _im=v_cwf_im_n([host UTF8String], [addr UTF8String], port, NSIm_on_cmd_nim_);
        _im->info=(__bridge void *)(self);
        _im->sck->evnh=NSIm_on_cmd_nim_sck_evn_h;
        
    }
    return self;
}
-(int)run:(int)erc{
    return v_cwf_im_run(_im, erc);
}
-(void)close{
    v_cwf_im_close(_im);
}
-(NSDictionary*)login:(NSDictionary*)args err:(NSError**)err{
    *err=nil;
    NSData* data;
    if(args){
        data=[args toJson:err];
        if(*err){
            return nil;
        }
    }else{
        data=[NSData dataWithBytes:"{}" length:2];
    }
    v_cwf_netw_cmd* targ=v_cwf_netw_cmd_n2((char*)data.bytes, (unsigned int)data.length);
    v_cwf_netw_cmd* ocmd;
    int res=v_cwf_im_li(_im, &targ, 1, &ocmd);
    v_cwf_netw_cmd_f(&targ);
    if(res!=0){
        *err=[NSError errorWithDomain:@"v_cwf_im_li" code:res userInfo:nil];
        return nil;
    }
    NSData* rdata=[NSData dataWithBytes:(ocmd->hb+ocmd->off) length:ocmd->len];
    NSDictionary* res_j=[rdata toJsonObject:err];
    if(*err){
        return nil;
    }
    v_cwf_netw_cmd_f(&ocmd);
    res=-1;
    NSNumber* code=[res_j objectForKey:@"code"];
    if(code){
        res=[code intValue];
    }
    if (res==0) {
        return [res_j objectForKey:@"res"];
    }else{
        *err=[NSError errorWithDomain:@"v_cwf_im_li" code:res userInfo:res_j];
        return nil;
    }
}
-(NSDictionary*)logout:(NSDictionary*)args err:(NSError**)err{
    *err=nil;
    NSData* data;
    if(args){
        data=[args toJson:err];
        if(*err){
            return nil;
        }
    }else{
        data=[NSData dataWithBytes:"{}" length:2];
    }
    v_cwf_netw_cmd* targ=v_cwf_netw_cmd_n2((char*)data.bytes, (unsigned int)data.length);
    v_cwf_netw_cmd* ocmd;
    int res=v_cwf_im_lo(_im, &targ, 1, &ocmd);
    v_cwf_netw_cmd_f(&targ);
    if(res!=0){
        *err=[NSError errorWithDomain:@"v_cwf_im_lo" code:res userInfo:nil];
        return nil;
    }
    NSDictionary* res_j=[[NSData dataWithBytes:(ocmd->hb+ocmd->off) length:ocmd->len]toJsonObject:err];
    if(*err){
        return nil;
    }
    v_cwf_netw_cmd_f(&ocmd);
    res=-1;
    NSNumber* code=[res_j objectForKey:@"code"];
    if(code){
        res=[code intValue];
    }
    if (res==0) {
        return [res_j objectForKey:@"res"];
    }else{
        *err=[NSError errorWithDomain:@"v_cwf_im_lo" code:res userInfo:res_j];
        return nil;
    }
}
-(NSDictionary*)ur:(NSDictionary*)args err:(NSError**)err{
    *err=nil;
    v_cwf_netw_cmd* targ=v_cwf_netw_cmd_n2("{}",2);
    v_cwf_netw_cmd* ocmd;
    int res=v_cwf_im_ur(_im, &targ, 1, &ocmd);
    v_cwf_netw_cmd_f(&targ);
    if(res!=0){
        *err=[NSError errorWithDomain:@"v_cwf_im_ur" code:res userInfo:nil];
        return nil;
    }
    NSDictionary* res_j=[[NSData dataWithBytes:(ocmd->hb+ocmd->off) length:ocmd->len]toJsonObject:err];
    if(*err){
        return nil;
    }
    v_cwf_netw_cmd_f(&ocmd);
    res=-1;
    NSNumber* code=[res_j objectForKey:@"code"];
    if(code){
        res=[code intValue];
    }
    if (res!=0) {
        *err=[NSError errorWithDomain:@"v_cwf_im_ur" code:res userInfo:res_j];
    }
    return nil;
}
-(int)sms:(ImMsg*)msg{
    if(msg==nil){
        return -1;
    }
    NSOutputStream* buf=[NSOutputStream outputStreamToMemory];
    [buf open];
    [msg writeToOutputStream:buf];
    NSData *data = [buf propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    [buf close];
    v_cwf_netw_cmd* targ=v_cwf_netw_cmd_n2((char*)data.bytes, (unsigned int)data.length);
    int res=v_cwf_im_sms(_im, &targ, 1);
    v_cwf_netw_cmd_f(&targ);
    if(res<1){
        return res;
    }else{
        return 0;
    }
}
-(int)mr:(NSString*)a mids:(NSString*)mids;{
    NSDictionary* args=[NSDictionary dictionaryWithObjectsAndKeys:a,@"a",mids,@"i", nil];
    NSData* data=[args toJson:nil];
    v_cwf_netw_cmd* targ=v_cwf_netw_cmd_n2((char*)data.bytes, (unsigned int)data.length);
    int res=v_cwf_im_mr(_im, &targ, 1);
    v_cwf_netw_cmd_f(&targ);
    return res;
}
-(void)start{
    NSILog(@"%@", @"start run im");
    _thr=[[NSThread alloc]initWithTarget:self selector:@selector(run:) object:0];
    [_thr start];
}
-(void)stop{
    NSILog(@"%@", @"stop im");
    [self close];
}
-(void)dealloc{
    v_cwf_im_f(&_im);
}
@end
