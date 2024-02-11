//
//  ConnectionMethods+Information.h
//  KCNetwork
//
//  Created by Jamie Evans on 2014-09-02.
//  Copyright (c) 2014 Kinetic Cafe. All rights reserved.
//

#import "ConnectionMethods.h"

@interface ConnectionMethods (Information)

+ (BOOL)networkReachable;

// Needs to be set before any network connections using baseURLByAppendingString
+ (NSString *)baseURLString;
+ (void)setBaseURLString:(NSString *)baseURLString;
+ (NSURL *)baseURLByAppendingString:(NSString *)specificAPICallString;

// Basic Timeout - Default is 30 seconds
+ (NSTimeInterval)timeoutInterval;
+ (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;

// Allows the statusbar network indicator to show during network connections - Default is YES
+ (BOOL)shouldShowNetworkIndicator;
+ (void)setShouldShowNetworkIndicator:(BOOL)shouldShowNetworkIndicator;

// Needs to be set before any multipart network connections
+ (NSString *)boundaryString;
+ (void)setBoundaryString:(NSString *)boundaryString;

// Default Value: NSURLRequestUseProtocolCachePolicy
// Other common values are NSURLRequestReloadIgnoringLocalAndRemoteCacheData (ignore all caching) and NSURLRequestReturnCacheDataElseLoad
+ (NSURLRequestCachePolicy)cachePolicy;
+ (void)setCachePolicy:(NSURLRequestCachePolicy)cachePolicy;
+ (void)clearCache;

@end
