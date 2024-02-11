//
//  ConnectionMethods+Authentication.h
//  KCNetwork
//
//  Created by Jamie Evans on 2014-08-28.
//  Copyright (c) 2014 Kinetic Cafe. All rights reserved.
//

#import "ConnectionMethods.h"

extern NSString * const kAuthorizationKey;

@interface ConnectionMethods (Authorization)

+ (NSString *)authorizationMethodWithUsername:(NSString *)username password:(NSString *)password url:(NSURL *)url andHTTPMethod:(NSString *)httpMethod;

@end
