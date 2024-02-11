//
//  ConnectionMethods+Logs.h
//  Pods
//
//  Created by Jamie Evans on 2014-09-03.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ConnectionMethods.h"

@interface ConnectionMethods (Logs)

+ (void)logRequest:(NSURLRequest *)request;
+ (void)logReturnWithData:(NSData *)data statusCode:(NSInteger)statusCode andError:(NSError *)error;

@end
