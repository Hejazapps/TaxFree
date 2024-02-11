//
//  ConnectionMethods+Information.m
//  Pods
//
//  Created by Jamie Evans on 2014-09-02.
//  Copyright (c) 2014 Kinetic Cafe. All rights reserved.
//

#import "ConnectionMethods+Information.h"
#import "Reachability.h"

static NSTimeInterval timeoutInterval = 30.0f;
static BOOL showsActivityIndicator    = YES;
static NSString *baseURLString        = @"";
static NSString *boundaryString       = nil;
static NSURLRequestCachePolicy policy = NSURLRequestUseProtocolCachePolicy;

@implementation ConnectionMethods (Information)

+ (BOOL)networkReachable{return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);}

// Base URL
+ (NSString *)baseURLString{return baseURLString;}
+ (void)setBaseURLString:(NSString *)_baseURLString{baseURLString = _baseURLString;}
+ (NSURL *)baseURLByAppendingString:(NSString *)specificAPICallString
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseURLString], specificAPICallString]];
}
// Timeout
+ (NSTimeInterval)timeoutInterval{return timeoutInterval;}
+ (void)setTimeoutInterval:(NSTimeInterval)_timeoutInterval{timeoutInterval = _timeoutInterval;}

// Network Indicator
+ (BOOL)shouldShowNetworkIndicator{return showsActivityIndicator;}
+ (void)setShouldShowNetworkIndicator:(BOOL)shouldShowNetworkIndicator{showsActivityIndicator = shouldShowNetworkIndicator;}

+ (NSString *)boundaryString{return (boundaryString ? : @"");}
+ (void)setBoundaryString:(NSString *)_boundaryString{boundaryString = _boundaryString;}

// Cache Policy
+ (NSURLRequestCachePolicy)cachePolicy{return policy;}
+ (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy{policy = cachePolicy;}
+ (void)clearCache
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
