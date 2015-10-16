//
//  RESTClient.m
//  BBH Mobile
//
//  Created by Mac-Mini on 9/16/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "RESTClient.h"

@implementation RESTClient

static RESTClient* instance;

+ (RESTClient *)instance {
    
    if(instance) {
        return instance;
    }
    
    NSBundle* bundle = [NSBundle mainBundle];
    instance = [[RESTClient alloc] initWithInfo:[bundle infoDictionary]];
    
    return instance;
}

- (instancetype) initWithInfo:(NSDictionary *)dict {
    
    self = [super init];
    if(self) {
        _serverURL = [dict valueForKey:@"Server URL"];
    }
    
    return self;
}

- (NSURL*) makeURLWithPath: (NSString*) path params:(RESTParams*) params {
    
    NSString* sURL = [NSString stringWithFormat:@"%@/%@", [self serverURL], path];
    
    if(params && ![params isEmpty]) {
        
        sURL = [NSString stringWithFormat:@"%@?%@", sURL, [params toQueryString]];
    }
    
    return [NSURL URLWithString:sURL];
}

-(void) setCredentialsWithUser:(NSString *)userName password:(NSString*) password {
    
    [self setCredentials:[[NSURLCredential alloc] initWithUser:userName password:password persistence:NSURLCredentialPersistenceNone]];
    
    NSString* authString = [NSString stringWithFormat:@"%@:%@", userName, password];
    NSData* authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* encodedAuth = [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    
    [self setBasicAuth:encodedAuth];
}

- (void) clearTLSCache {
    
    NSDictionary* credsDict = [[NSURLCredentialStorage sharedCredentialStorage] allCredentials];
    NSEnumerator* iter = [credsDict keyEnumerator];
    id ps;
    
    while ((ps = [iter nextObject])) {
        
        NSEnumerator* userIter = [[credsDict valueForKey:ps] keyEnumerator];
        
        id user;
        NSURLCredential* cred;
        
        while ((user = [userIter nextObject])) {
            
            cred = [[credsDict valueForKey:ps] valueForKey:user];
            NSLog(@">> User: %@ - cred: %@ - ps: %@",user, cred, [ps realm]);
            
            [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:cred forProtectionSpace:ps];
        }
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* cookies = [cookieStorage cookies];
    
    for(NSHTTPCookie* c in cookies) {
        [cookieStorage deleteCookie:c];
    }
}

-(void) doConnectWithRequest: (NSMutableURLRequest*) request handler: (NSObject<RESTResponseHandler>*)handler {
    
    [self clearTLSCache];
    
    RESTDelegate* delegate = [[RESTDelegate alloc] initWithHandler:handler];
    [delegate setCredential:[self credentials]];
    
    if([self accessToken]) {
        
        [request setValue:[self accessToken] forHTTPHeaderField:@"token"];
        
    } else {
        
        //NSLog(@">> Adding Basic Auth: %@", [NSString stringWithFormat:@"Basic %@",[self basicAuth]]);
        //[request setValue:[NSString stringWithFormat:@"Basic %@",[self basicAuth]] forHTTPHeaderField:@"Authorization"];
    }
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:delegate startImmediately:NO];
    [conn setDelegateQueue:[NSOperationQueue mainQueue]];
    [conn start];
}

/** RESTClient Interface Implementation **/

-(void)doGETWithURL:(NSString *)path data:(RESTParams *)params handler:(NSObject<RESTResponseHandler> *)handler {
    
    [self doGETWithURL:path absolute:NO data:params handler:handler];
}

- (void)doGETWithURL:(NSString *)path absolute:(BOOL)abosolute data:(RESTParams *)params handler:(NSObject<RESTResponseHandler> *)handler {
    
    NSURL* url = abosolute ? [NSURL URLWithString:path] : [self makeURLWithPath:path params:params];
    NSLog(@"GET Server URL: %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [self doConnectWithRequest:request handler:handler];
}

-(void)doPOSTWithURL:(NSString *)path data:(RESTParams *)params handler:(NSObject<RESTResponseHandler> *)handler {
    
    NSURL* url = [self makeURLWithPath:path params:nil];
    NSLog(@"POST Server URL: %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data = [[params toQueryString] dataUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    [self doConnectWithRequest:request handler:handler];
}

-(void)doPUTWithURL:(NSString *)path data:(RESTParams *)params handler:(NSObject<RESTResponseHandler> *)handler {
    //
}

@end