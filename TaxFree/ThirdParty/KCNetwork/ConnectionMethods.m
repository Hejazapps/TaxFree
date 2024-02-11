//
//  ConnectionMethods.m
//  IP Workspace
//
//  Created by Jamie Evans on 2012-09-10.
//  Copyright (c) 2012 VRG Interactive Inc. All rights reserved.
//

#import "ConnectionMethods.h"
#import "ConnectionMethods+Parsing.h"
#import "NSMutableURLRequest+Headers.h"
#import "ConnectionMethods+Information.h"
#import "ConnectionMethods+Logs.h"
//#import "Reachability.h"

NSString * const kContentLengthKey = @"Content-Length";
NSString * const kContentTypeKey   = @"Content-Type";
NSString * const kAcceptKey   = @"Accept";

NSString * const kHTTPMethodGet    = @"GET";
NSString * const kHTTPMethodPost   = @"POST";
NSString * const kHTTPMethodPut    = @"PUT";
NSString * const kHTTPMethodDelete = @"DELETE";

NSString * const kContentTypeData      = @"x-www-form-urlencoded";
NSString * const kContentTypeJSON      = @"application/json";
NSString * const kContentTypeVIDEO     = @"application/octet-stream";
NSString * const kContentTypeMultipart = @"multipart/form-data";
NSString * const kContentTypeMultipartWithPUT = @"application/x-www-form-urlencoded";

NSString* secretHeaderKey;
NSString* secretHeaderValue;

@interface ConnectionMethods ()

//+ (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod;
//+ (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod data:(NSData *)data;
+ (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod data:(NSData *)data contentType:(NSString *)contentType;
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode;
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode urlData:(NSData*)urlData;
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url JSONData:(NSData *)JSONData withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode;
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url data:(NSData *)data withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode;
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url multipartData:(NSData *)data withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode;
+ (NSData *)sendRequest:(NSMutableURLRequest *)request withStatusCodePointer:(NSInteger *)statusCode;

@property (nonatomic) NSString* secretHeaderKey;
@property (nonatomic) NSString* secretHeaderValue;

@end

@implementation ConnectionMethods

+ (void)requestWithURL:(NSURL *)url forType:(RequestType)type httpMethod:(NSString *)httpMethod data:(NSData *)data callback:(FullResponseCallback)callback
{
    
    [ConnectionMethods setBoundaryString:@"--WebKitFormBoundaryBdg4DWHAHUooMOip"];
    [ConnectionMethods setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
                   {
                       NSInteger statusCode = 0;
                       NSData *returnData = nil;
                       switch(type)
                       {
                           case RequestTypeURL:
                           {                               
                               returnData = [ConnectionMethods startSynchronousConnectionWithURL:url
                                                                                  withHTTPMethod:httpMethod
                                                                                      statusCode:&statusCode];
                               break;
                           }
                               
                           case RequestTypeJSON:
                           {
                               returnData = [ConnectionMethods startSynchronousConnectionWithURL:url
                                                                                        JSONData:data
                                                                                  withHTTPMethod:httpMethod
                                                                                      statusCode:&statusCode];
                               break;
                           }
                               
                           case RequestTypeData:
                           {
                               
                               returnData = [ConnectionMethods startSynchronousConnectionWithURL:url
                                                                                            data:data
                                                                                  withHTTPMethod:httpMethod
                                                                                      statusCode:&statusCode];
                               break;
                           }
                               
                           case RequestTypeMultipart:
                           {
                               returnData = [ConnectionMethods startSynchronousConnectionWithURL:url
                                                                                   multipartData:data
                                                                                  withHTTPMethod:httpMethod
                                                                                      statusCode:&statusCode];
                               break;
                           }
                       }
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          if(callback)callback((ResponseStatus)statusCode, [self parseJSONData:returnData]);
                                      });
                   });
}

+ (void)requestWithURL:(NSURL *)url forType:(RequestType)type httpMethod:(NSString *)httpMethod data:(NSData *)data secretKey:(NSString*)secretKey secretValue:(NSString*)secretValue callback:(FullResponseCallback)callback
{
    //    if(![self networkReachable])
    //    {
    //        callback(ResponseStatusNoNetwork, @"Network Error");
    //        return;
    //    }
    
    secretHeaderKey = secretKey;
    secretHeaderValue = secretValue;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
                   {
                       NSInteger statusCode = 0;
                       NSData *returnData = nil;
                       switch(type)
                       {
                           case RequestTypeURL:
                           {
                               
                               returnData = [ConnectionMethods startSynchronousConnectionWithURL:url
                                                                                  withHTTPMethod:httpMethod
                                                                                      statusCode:&statusCode];
                               break;
                           }
                               
                           case RequestTypeJSON:
                           {
                               returnData = [ConnectionMethods startSynchronousConnectionWithURL:url
                                                                                        JSONData:data
                                                                                  withHTTPMethod:httpMethod
                                                                                      statusCode:&statusCode];
                               break;
                           }
                               
                           case RequestTypeData:
                           {
                               
                               returnData = [ConnectionMethods startSynchronousConnectionWithURL:url
                                                                                            data:data
                                                                                  withHTTPMethod:httpMethod
                                                                                      statusCode:&statusCode];
                               break;
                           }
                               
                           case RequestTypeMultipart:
                           {
                               returnData = [ConnectionMethods startSynchronousConnectionWithURL:url
                                                                                   multipartData:data
                                                                                  withHTTPMethod:httpMethod
                                                                                      statusCode:&statusCode];
                               break;
                           }
                       }
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          if(callback)callback((ResponseStatus)statusCode, [self parseJSONData:returnData]);
                                      });
                   });
}

+ (NSMutableURLRequest *)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)httpMethod data:(NSData *)data contentType:(NSString *)contentType
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:0
                                                       timeoutInterval:self.timeoutInterval];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    [request applyStandardHeaders];
    if(secretHeaderValue != nil)
        [request setValue:secretHeaderValue forHTTPHeaderField:secretHeaderKey];
    [request setHTTPMethod:httpMethod];
    if(data.length)
    {
        [request setValue:@(data.length).stringValue forHTTPHeaderField:kContentLengthKey];
        [request setHTTPBody:data];
    }
   
    if(contentType.length)[request setValue:contentType forHTTPHeaderField:kContentTypeKey];
//    [request addValue:contentType forHTTPHeaderField:kAcceptKey];
    
    return request;
}

// URL
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode
{
    return [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:nil contentType:nil] withStatusCodePointer:statusCode];
}
// URL WITH DATA
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode urlData:(NSData*)urlData
{
    return [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:urlData contentType:nil] withStatusCodePointer:statusCode];
}

// JSON
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url JSONData:(NSData *)JSONData withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode
{
    return [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:JSONData contentType:kContentTypeJSON] withStatusCodePointer:statusCode];
}
// Data
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url data:(NSData *)data withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode
{
    return [self sendRequest:[self requestWithURL:url HTTPMethod:httpMethod data:data contentType:kContentTypeData] withStatusCodePointer:statusCode];
}

// Multipart Form
+ (NSData *)startSynchronousConnectionWithURL:(NSURL *)url multipartData:(NSData *)data withHTTPMethod:(NSString *)httpMethod statusCode:(NSInteger *)statusCode
{
    return [self sendRequest:[self requestWithURL:url
                                       HTTPMethod:httpMethod
                                             data:data
                                      contentType:[NSString stringWithFormat:@"%@;%@", kContentTypeMultipart, (self.boundaryString.length ? [@" boundary=" stringByAppendingString:self.boundaryString] : @"")]]
       withStatusCodePointer:statusCode];
    
}

+ (NSData *)sendRequest:(NSMutableURLRequest *)request withStatusCodePointer:(NSInteger *)statusCode
{
    
    [self logRequest:request];
    
//    if(self.shouldShowNetworkIndicator)[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLResponse *response = nil;
    NSError *error; 
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    *statusCode = [(NSHTTPURLResponse *)response statusCode];
    
    [self logReturnWithData:returnData statusCode:*statusCode andError:error];
    
//    if(self.shouldShowNetworkIndicator)[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    return returnData;
}

@end
