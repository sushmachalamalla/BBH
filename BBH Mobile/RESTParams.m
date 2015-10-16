//
//  RESTParams.m
//  BBH Mobile
//
//  Created by Mac-Mini on 9/22/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import "RESTClient.h"

@implementation RESTParams

-(instancetype)init {
    return [self initWithDict:[NSMutableDictionary dictionary]];
}

- (instancetype)initWithDict: (NSMutableDictionary*) params {
    
    self = [super init];
    if(self) {
        _params = params;
    }
    
    return self;
}

- (void)addParam:(NSString *)param withValue:(id)value {
    
    if([[self params] valueForKey:param] == nil) {
        
        [[self params] setValue:[NSMutableArray array] forKey:param];
    }
    
    [((NSMutableArray*)[[self params] valueForKey:param]) addObject:value];
}

- (int)size {
    return [[self params] count];
}

- (BOOL)isEmpty {
    return [self size] == 0;
}

- (NSString *)toQueryString {
    
    NSMutableString* query = [NSMutableString string];
    [[self params] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        
        CFStringRef encKey =
            CFURLCreateStringByAddingPercentEscapes(
                kCFAllocatorDefault,
                (__bridge CFStringRef)key,
                NULL,
                //CFSTR(":/?#[]@!$&'()*+,;="),
                NULL,
                kCFStringEncodingUTF8);
        
        [(NSMutableArray*)obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            
            CFStringRef encObj =
                CFURLCreateStringByAddingPercentEscapes(
                    kCFAllocatorDefault,
                    (__bridge CFStringRef)obj,
                    NULL,
                    //CFSTR(":/?#[]@!$&'()*+,;="),
                    NULL,
                    kCFStringEncodingUTF8);
            
            [query appendFormat:@"%@=%@&", (__bridge NSString*)encKey, (__bridge NSString*)encObj];
        }];
    }];
    
    int toIdx = [query length]-1;
    return [query substringToIndex:toIdx < 0 ? 0 : toIdx];
}

@end