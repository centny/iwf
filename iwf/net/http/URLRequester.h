//
//  URLRequester.h
//  NCardSet
//
//  Created by Centny on 4/10/13.
//  Copyright (c) 2013 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
//
#define URL_TIME_OUT		10
//#define NO_NETWORK_NOTICE	@"NO_NETWORK"

//
FOUNDATION_EXPORT NSString* HC_C; //cache only.
FOUNDATION_EXPORT NSString* HC_CN; //cache first.
FOUNDATION_EXPORT NSString* HC_NC; //http first.
FOUNDATION_EXPORT NSString* HC_N; //normal http cache.
FOUNDATION_EXPORT NSString* HC_I; //image cache.
FOUNDATION_EXPORT NSString* HC_NO; //no cache.
//
FOUNDATION_EXPORT NSString* HC_KEY; //http cache arguments key.
//
@class URLRequester,MultipartBuilder;

typedef void (^ URLReqCompleted)(URLRequester *req, NSData* data, NSError *err);
typedef void (^ URLReqStart)(URLRequester *req, NSMutableURLRequest *request);
typedef void (^ URLReqProcUp)(URLRequester *req, NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpected);
typedef void (^ URLReqProcDown)(URLRequester *req, NSData * recv, NSInteger total);

/**
 *    the URL request delegate.
 *    @author Centny
 */
@protocol URLRequesterDelegate <NSObject>
@optional
/**
 *    call back when request end.
 *    @param req the requester instance.
 *    @param msg nil is request success,or failed.
 */
- (void)onReqCompleted:(URLRequester*)req data:(NSData*)data err:(NSError*)err;
- (void)onReqStart:(URLRequester*)req request:(NSMutableURLRequest*) request;
- (void)onReqProcUp:(URLRequester*)req bytesWritten:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpected:(NSInteger)totalBytesExpected;
- (void)onReqProcDown:(URLRequester*)req recv:(NSData*)recv total:(NSInteger)total;
@end

/**
 *    the URL requester.
 *    @author Centny
 */
@interface URLRequester : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
//
@property(nonatomic, readonly) NSMutableURLRequest	*request;
@property(nonatomic, readonly) NSURLConnection		*connection;
//
@property(nonatomic, assign) NSStringEncoding		encoding;	// default is UTF-8.
@property(nonatomic, retain) NSString				*url;		// target URL.
@property(nonatomic, retain) NSString				*method;	// default is GET.
//@property(nonatomic, retain) NSString               *req_t;     // the request content type.
@property(nonatomic, readonly) MultipartBuilder     *multipart;
@property(nonatomic) long							timeout;
@property(nonatomic, readonly) NSMutableDictionary	*args;		// request arguments.
@property(nonatomic, readonly) NSMutableDictionary	*req_h;		// request header fields.
//
@property(nonatomic, readonly) NSDictionary			*res_h;		// response header fields.
@property(nonatomic, readonly) NSData				*res_d;		// response data
@property(nonatomic, readonly) NSHTTPURLResponse	*response;	//
@property(nonatomic, readonly) NSString				*sdata;		// response string data by encoding.
@property(nonatomic, readonly) NSInteger			statusCode;
@property(nonatomic, readonly) NSInteger			clength;
@property(nonatomic, copy)     NSString             *policy;
@property(nonatomic, readonly) NSURLRequestCachePolicy policy_;
//
@property(nonatomic, retain) NSData* body;
@property(nonatomic, retain) NSInputStream *streamBody;
@property(nonatomic, assign) id <URLRequesterDelegate>	delegate;
@property(nonatomic, copy) URLReqCompleted				completed;
@property(nonatomic, copy) URLReqStart                  onstart;	// call it before start.
@property(nonatomic, copy) URLReqProcUp                 onup;
@property(nonatomic, copy) URLReqProcDown               ondown;
@property(nonatomic, readonly)NSString              *fullUrl;
@property(nonatomic)BOOL main;

//
+ (void)setQueue:(NSOperationQueue*)queue;
+ (void)setHTTPShouldHandleCookies:(BOOL)should;
//
- (void)addURLArgs:(NSString *)args;
- (void)addDictArgs:(NSDictionary *)dict;
- (void)addArgBy:(NSString *)key value:(NSString *)value;
- (void)addHeaderField:(NSString *)key value:(NSString *)value;
//
- (NSString *)codingData:(NSStringEncoding)coding;
- (void)start;
- (void)cancel;
///
- (void)onReqCompleted:(NSData*)data err:(NSError*)err;
- (void)onReqStart:(NSMutableURLRequest*) request;
- (void)onReqProcUp:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpected:(NSInteger)totalBytesExpected;
- (void)onReqProcDown:(NSData*)recv total:(NSInteger)total;
@end
