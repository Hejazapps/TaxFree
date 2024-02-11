//
//  ConnectionMethods.h
//  IP Workspace
//
//  Created by Jamie Evans on 2012-09-10.
//  Copyright (c) 2012 VRG Interactive Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSJSONSerialization+RemovingNulls.h"

typedef enum
{
    ResponseStatusNoNetwork = 0,
    ResponseStatusOK = 200,
    ResponseStatusCreated = 201,
    ResponseStatusNotFound = 204,
    ResponseStatusRequestError = 300,
    ResponseStatusUnknownError = 301,
    ResponseStatusInvalidRequest = 400,
    ResponseStatusNotAuthorized = 401,
    ResponseStatusEndPointNotFound = 404,
    ResponseStatusServerError = 500,
    ResponseStatusInvalidCredentials = 402
} ResponseStatus;


typedef void (^ResponseCallback)(ResponseStatus status);

extern NSString * const kContentLengthKey;
extern NSString * const kContentTypeKey;

extern NSString * const kHTTPMethodGet;
extern NSString * const kHTTPMethodPost;
extern NSString * const kHTTPMethodPut;
extern NSString * const kHTTPMethodDelete;

extern NSString * const kContentTypeData;
extern NSString * const kContentTypeJSON;
extern NSString * const kContentTypeVIDEO;
extern NSString * const kContentTypeMultipart;

// Response object could be NSArray, NSDictionary or NSString
typedef void (^FullResponseCallback)(ResponseStatus status, id responseObject);

typedef enum
{
    RequestTypeURL = 0,
    RequestTypeJSON,
    RequestTypeData,
    RequestTypeMultipart
} RequestType;

@interface ConnectionMethods : NSObject



// Use this for main requests
+ (void)requestWithURL:(NSURL *)url forType:(RequestType)type httpMethod:(NSString *)httpMethod data:(NSData *)data callback:(FullResponseCallback)callback;

+ (void)requestWithURL:(NSURL *)url forType:(RequestType)type httpMethod:(NSString *)httpMethod data:(NSData *)data secretKey:(NSString*)secretKey secretValue:(NSString*)secretValue callback:(FullResponseCallback)callback;

@end
