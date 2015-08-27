//
//  FPis.m
//  iwf
//
//  Created by Centny on 8/27/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "FPis.h"
#import "../../core/CoreMethod.h"
@interface FPis()
@property(nonatomic,assign)long reaed;
@end
@implementation FPis
- (instancetype)initWithPath:(NSString *)path name:(NSString*)name filename:(NSString*)filename type:(NSString*)type length:(long)length{
    self=[self initWithBase:[NSInputStream inputStreamWithFileAtPath:path]];
    if(self){
        _path=path;
        _name=name;
        _filename=filename;
        _type=type;
        _clength=length;
        if(!self.type){
            _type=@"application/octet-stream";
        }
        NSMutableString *data=[NSMutableString string];
        [data appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",self.name,self.filename];
        [data appendFormat:@"Content-Type: %@\r\n",self.type];
        if(self.clength){
            [data appendFormat:@"Content-Length: %ld\r\n",self.clength];
        }
        _head=[data dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}
- (instancetype)initWithData:(NSData *)data name:(NSString*)name{
    self=[super initWithBase:[NSInputStream inputStreamWithData:data]];
    if(self){
        _name=name;
        NSMutableString *data=[NSMutableString string];
        [data appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",self.name];
        _head=[data dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}
- (instancetype)initWithString:(NSString *)data name:(NSString*)name{
    self=[super initWithBase:[NSInputStream inputStreamWithData:[data dataUsingEncoding:NSUTF8StringEncoding]]];
    if(self){
        _name=name;
        NSMutableString *data=[NSMutableString string];
        [data appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",self.name];
        _head=[data dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}
- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len{
    NSInteger rlen=0;
    if(self.reaed>=self.head.length){
        rlen=[super read:buffer maxLength:len];
        if(rlen>0){
            self.reaed+=rlen;
        }
        return rlen;
    }
    rlen=(NSInteger)(self.head.length-self.reaed);
    if(rlen>len){
        rlen=(NSInteger)len;
    }
    dataccpy(buffer, 0, self.head, self.reaed, rlen);
    self.reaed+=rlen;
    return rlen;
}
- (BOOL)hasBytesAvailable{
    if(self.reaed>=self.head.length){
        return [super hasBytesAvailable];
    }else{
        return true;
    }
}
@end
