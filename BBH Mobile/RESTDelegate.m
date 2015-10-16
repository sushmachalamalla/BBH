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

- (instancetype)init {
    
    return [self initWithHandler:nil];
}

- (instancetype)initWithHandler: (NSObject<RESTResponseHandler> * __nonnull) handler {
    
    self = [super init];
    if(self) {
        _responseHandler = handler;
        _statusCode = -1;
    }
    
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"Done");
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
    
    [[self responseHandler] failure:dict withMessage: [NSString stringWithFormat:@"An error occured while fetching"]];
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
    
    NSError* jsonError;
    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    NSMutableDictionary* dict = nil;
    
    if(jsonError == NULL) {
        
        dict = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)json];
        [dict setValue:__headers forKey:@"headers"];
        
        if([self statusCode] == 200) {
            [[self responseHandler] success:dict];
        } else {
            [[self responseHandler] failure:dict withMessage:[self statusCode] == 401 ? @"Incorrect creadentials, please try again." : @"An error occured"];
        }
        
    } else {
        
        NSLog(@"JSON-error: %@", [jsonError description]);
        NSLog(@"html: %@", [NSString stringWithUTF8String:[data bytes]]);
        
        dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSNumber numberWithInt:[jsonError code]] forKey:@"code"];
        [dict setValue:[jsonError description] forKey:@"description"];
        [[self responseHandler] failure:dict withMessage:@"An error occured"];
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    NSLog(@"didSendBodyData:%li", (long)totalBytesWritten);
}

@end