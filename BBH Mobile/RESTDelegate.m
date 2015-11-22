//
//  RESTDelegate.m
//  BBH Mobile
//
//  Created by Mac-Mini on 9/22/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "RESTClient.h"

@implementation RESTDelegate {
    
    NSDictionary* __headers;
}

//@synthesize responseHandler;

- (instancetype)init {
    
    return [self initWithHandler:nil];
}

- (instancetype)initWithHandler: (void(^)(RESTResponse, NSDictionary*)) handler {
    
    self = [super init];
    if(self) {
        _responseHandler = handler;
        _statusCode = -1;
        _responseData = [NSMutableData data];
    }
    
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError* jsonError;
    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:[self responseData] options:kNilOptions error:&jsonError];
    
    NSMutableDictionary* dict = nil;
    
    if(jsonError == NULL) {
        
        dict = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)json];
        [dict setValue:__headers forKey:@"headers"];
        
        if([self statusCode] == 200) {
            
            [self responseHandler](RESTResponseSuccess, dict);
            
        } else {
            
            [dict setValue:[self statusCode] == 401 ? @"Incorrect credentials, please try again." : @"An error occured" forKey:@"message"];
            
            [self responseHandler](RESTResponseError, dict);
        }
        
    } else {
        
        NSLog(@"JSON-error: %@", [jsonError description]);
        NSLog(@"html: %@", [NSString stringWithUTF8String:[[self responseData] bytes]]);
        
        dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSNumber numberWithInt:[jsonError code]] forKey:@"code"];
        [dict setValue:[jsonError description] forKey:@"description"];
        [dict setValue:@"An error occurred" forKey:@"description"];
        
        [self responseHandler](RESTResponseError, dict);
    }
    
    NSLog(@"Connected");
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NSLog(@"willSendRequestForAuthenticationChallenge:%@", [[self credential] user] );
    [[challenge sender] useCredential:[self credential] forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError:%@", error);
    NSDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSNumber numberWithInt:[error code]] forKey:@"code"];
    [dict setValue:[error description] forKey:@"description"];
    [dict setValue:[NSString stringWithFormat:@"An error occured while fetching"] forKey:@"message"];
    
    [self responseHandler](RESTResponseError, dict);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    NSLog(@"response status: %li", (long)[httpResponse statusCode]);
    NSLog(@"response type: %@", [httpResponse MIMEType]);
    NSLog(@"response length: %lld", [httpResponse expectedContentLength]);
    
    [self setStatusCode:[httpResponse statusCode]];
    __headers = [httpResponse allHeaderFields];
    
    /*[[httpResponse allHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        NSLog(@"%@ -> %@", key, obj);
    }];*/
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    //NSLog(@"didReceiveData:%@", data);
    [[self responseData] appendData:data];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    NSLog(@"didSendBodyData:%li", (long)totalBytesWritten);
}

@end