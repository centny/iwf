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
#import <iwf/iwf-Swift.h>

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
- (instancetype)initWithBound:(NSString*)bound args:(NSDictionary*)args{
    self=[super init];
    if(self){
        _datas=[NSMutableDictionary dictionary];
        self.bound=bound;
        [self addArgs:args];
    }
    return self;
}
- (instancetype)initWithBound:(NSString*)bound args:(NSDictionary*)args name:(NSString*)name path:(NSString*)path{
    self=[super init];
    if(self){
        _datas=[NSMutableDictionary dictionary];
        self.bound=bound;
        [self buildPath:path name:name];
        [self addArgs:args];
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
    if(!path||!name){
        return;
    }
    self.name=name;
    self.path=path;
    self.filename=path.lastPathComponent;
    self.type=mimetype(self.filename);
    self.clength=[Util fsize:path];
}
- (NSInputStream*)build{
    if(self.datas.count<1 &&self.path==nil){
        return nil;
    }
    NSDataInputStream *dis=[[NSDataInputStream alloc]init];
    for (NSString* name in self.datas.keyEnumerator) {
        [dis appendStr:[NSString stringWithFormat:@"--%@\r\n",self.bound] end:false];
        [dis appendStr:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",name] end:false];
        [dis appendData:[self.datas objectForKey:name] end:false];
        [dis appendStr:@"\r\n" end:false];
    }
    if(self.path){
        [dis appendStr:[NSString stringWithFormat:@"--%@\r\n",self.bound] end:false];
        [dis appendStr:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",self.name,self.filename] end:false];
        if(self.clength){
            [dis appendStr:[NSString stringWithFormat:@"Content-Length: %ld\r\n",self.clength] end:false];
        }
        [dis appendStr:[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",self.type] end:false];
        dis.base=[[NSInputStream alloc]initWithFileAtPath:self.path];
        [dis appendStr:@"\r\n" end:true];
    }else{
        dis.base=[[NSInputStream alloc]initWithData:[NSData data]];
    }
    [dis appendStr:[NSString stringWithFormat:@"--%@--\r\n",self.bound] end:true];
    return dis;
}
+ (MultipartBuilder*)builderWith:(NSDictionary*)args name:(NSString*)name path:(NSString*)path{
    return [[MultipartBuilder alloc]initWithBound:nuuid() args:args name:name path:path];
}
@end
