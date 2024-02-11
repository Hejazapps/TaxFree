//
//  NSMutableURLRequest+Headers.m
//  Pods
//
//  Created by Jamie Evans on 2014-09-02.
//  Copyright (c) 2014 Kinetic Cafe. All rights reserved.
//

#import "NSMutableURLRequest+Headers.h"
#import "NSObject+Swizzle.h"

static NSDictionary *standardHeaders = nil;

@implementation NSMutableURLRequest (Headers)

+ (NSDictionary *)standardHeaders{return standardHeaders;}
+ (void)setStandardHeaders:(NSDictionary *)_standardHeaders{standardHeaders = _standardHeaders;}

+ (void)extendHeadersWithSelector:(SEL)extendedHeadersSelector
{
    [[self class] swizzleSelector:@selector(applyStandardHeaders) withLocalSelector:extendedHeadersSelector];
}

- (void)applyStandardHeaders
{
    for(NSString *key in standardHeaders.allKeys)
    {
        [self setValue:standardHeaders[key] forHTTPHeaderField:key];
    }
}

@end
