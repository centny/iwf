//
//  MultipartStream.m
//  iwf
//
//  Created by Centny on 8/27/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "MultipartStream.h"
#import "FPis.h"
#import "../../core/CoreMethod.h"

@interface MultipartStream ()
@property(nonatomic,assign)int idx;
@property(nonatomic,retain)NSData *bound_;
@property(nonatomic,assign)NSUInteger breaded;
@end
@implementation MultipartStream

- (instancetype)initWithBound:(NSString *)bound{
    self=[super init];
    if(self){
        self.idx=0;
        _bound=bound;
        _bound_=[[NSString stringWithFormat:@"--%@\r\n",self.bound]dataUsingEncoding:NSUTF8StringEncoding];
        _breaded=0;
        _pis=[NSMutableArray array];
    }
    return self;
}

- (void)addPis:(FPis *)pis{
    [self.pis addObject:pis];
}
- (void)open{
    for (FPis *pis in self.pis) {
        [pis open];
    }
}
- (void)close{
    for (FPis *pis in self.pis) {
        [pis close];
    }
}
- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len{
    NSUInteger rlen;
    if(self.breaded<self.bound_.length-1){
        rlen=dataccpy(buffer, 0, self.bound_, self.breaded, len);
        self.breaded+=rlen;
        return rlen;
    }
    if(self.idx>=self.pis.count){
        return -1;
    }
    FPis *pis=[self.pis objectAtIndex:self.idx];
    rlen=[pis read:buffer maxLength:len];
    if(rlen>0){
        return rlen;
    }
    self.idx++;
    if(self.idx<self.pis.count){
        self.breaded=0;
        _bound_=[[NSString stringWithFormat:@"\n\n--%@\r\n",self.bound]dataUsingEncoding:NSUTF8StringEncoding];
        return [self read:buffer maxLength:len];
    }else{
        self.breaded=0;
        _bound_=[[NSString stringWithFormat:@"\n\n--%@--\r\n",self.bound]dataUsingEncoding:NSUTF8StringEncoding];
        return [self read:buffer maxLength:len];
    }
}
- (BOOL)hasBytesAvailable{
    if(self.breaded<self.bound_.length-1){
        return true;
    }else{
        return self.idx<self.pis.count;
    }
}
@end
