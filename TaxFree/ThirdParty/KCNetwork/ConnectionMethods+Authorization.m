//
//  ConnectionMethods+Authentication.m
//  KCPinTucker
//
//  Created by Jamie Evans on 2014-08-28.
//  Copyright (c) 2014 Kinetic Cafe. All rights reserved.
//

#import "ConnectionMethods+Authorization.h"

NSString * const kAuthorizationKey = @"Authorization";

@implementation ConnectionMethods (Authorization)

+ (NSString *)authorizationMethodWithUsername:(NSString *)username password:(NSString *)password url:(NSURL *)url andHTTPMethod:(NSString *)httpMethod
{
    // Cast username and password as CFStringRefs via Toll-Free Bridging
    CFStringRef usernameRef = (__bridge CFStringRef)username;
    CFStringRef passwordRef = (__bridge CFStringRef)password;
    
    // Reference properties of the NSMutableURLRequest
    CFHTTPMessageRef authorizationMessageRef = CFHTTPMessageCreateRequest(kCFAllocatorDefault, (__bridge CFStringRef)httpMethod, (__bridge CFURLRef)url, kCFHTTPVersion1_1);
    
    // Encodes usernameRef and passwordRef in Base64
    CFHTTPMessageAddAuthentication(authorizationMessageRef, nil, usernameRef, passwordRef, kCFHTTPAuthenticationSchemeBasic, FALSE);
    
    // Creates the 'Basic - <encoded_username_and_password>' string for the HTTP header
    CFStringRef authorizationStringRef = CFHTTPMessageCopyHeaderFieldValue(authorizationMessageRef, (__bridge CFStringRef)kAuthorizationKey);
    
    // Add authorizationStringRef as value for 'Authorization' HTTP header
    NSString *authorizationMessage = (__bridge NSString *)authorizationStringRef;
    
    // Cleanup
    CFRelease(authorizationStringRef);
    CFRelease(authorizationMessageRef);
    
    return authorizationMessage;
}

@end
