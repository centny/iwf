//
//  MultipartStream.m
//  iwf
//
//  Created by Centny on 8/27/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

#import "MultipartBuilder.h"
#import "../../core/CoreMethod.h"
#import <iwf/iwf.h>
//#import <iwf/iwf-Swift.h>

@interface MultipartBuilder ()
@end
@implementation MultipartBuilder
- (instancetype)initWithBound:(NSString*)bound{
    self=[super init];
    if(self){
        _datas=[NSMutableDictionary dictionary];
        self.bound=[bound stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    return self;
}
- (void)addArgs:(NSDictionary *)args{
    if(!args){
        return;
    }
    for(NSString* key in args.keyEnumerator){
        NSObject* val = [args objectForKey:key];
        if([val isKindOfClass:[NSData class]]){
            [self.datas setObject:val forKey:key];
        }else if([val isKindOfClass:[NSString class]]){
            val = [((NSString*)val)dataUsingEncoding:NSUTF8StringEncoding];
            [self.datas setObject:val forKey:key];
        }
    }
}
- (void)buildPath:(NSString*)path name:(NSString*)name{
    self.name=name;
    self.path=path;
    self.filename=path.lastPathComponent;
    self.type=mimetype(self.filename);
    self.clength=[Util fsize:path];
}
- (void)buildData:(NSData*)data name:(NSString*)name filename:(NSString*)filename type:(NSString*)type{
    self.name=name;
    self.filename=filename;
    self.type=type;
    self.data=data;
}
- (NSInputStream*)build{
    if(self.datas.count<1 &&self.name==nil){
        return nil;
    }
    NSDataInputStream *dis=[[NSDataInputStream alloc]init];
    for (NSString* name in self.datas.keyEnumerator) {
        [dis appendStr:[NSString stringWithFormat:@"--%@\r\n",self.bound] end:false];
        [dis appendStr:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",name] end:false];
        [dis appendData:[self.datas objectForKey:name] end:false];
        [dis appendStr:@"\r\n" end:false];
    }
    if(self.name){
        [dis appendStr:[NSString stringWithFormat:@"--%@\r\n",self.bound] end:false];
        [dis appendStr:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",self.name,self.filename] end:false];
        if(self.clength){
            [dis appendStr:[NSString stringWithFormat:@"Content-Length: %ld\r\n",self.clength] end:false];
        }
        [dis appendStr:[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",self.type] end:false];
        if(self.data){
            [dis appendData:self.data end:false];
            [dis appendStr:[NSString stringWithFormat:@"\r\n--%@--\r\n",self.bound] end:false];
        }else{
            dis.base=[[NSInputStream alloc]initWithFileAtPath:self.path];
            [dis appendStr:[NSString stringWithFormat:@"\r\n--%@--\r\n",self.bound] end:true];
        }
    }else{
        [dis appendStr:[NSString stringWithFormat:@"--%@--\r\n",self.bound] end:false];
    }
    if(dis.base){
        //having file.
        return dis;
    }else{
        //not file,using normal inputstream.
        return [NSInputStream inputStreamWithData:dis.data_b];
    }
}
+ (MultipartBuilder*)builder{
    return [[MultipartBuilder alloc]initWithBound:nuuid()];
}
@end
