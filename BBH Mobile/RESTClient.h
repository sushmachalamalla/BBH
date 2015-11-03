//
//  RESTClient.h
//  BBH Mobile
//
//  Created by Mac-Mini on 9/16/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RESTResponse) {
    
    RESTResponseSuccess, RESTResponseError, RESTResponseProgress
};

@protocol RESTResponseHandler <NSObject>

-(void) success: (NSDictionary*) data;
-(void) failure: (NSDictionary*) detail withMessage: (NSString*) message;
-(void) progress: (NSNumber*) percent;

@end

@interface RESTDelegate : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

-(instancetype) init;
-(instancetype) initWithHandler: (void(^)(RESTResponse,NSDictionary*)) handler;

@property int statusCode;
@property NSURLCredential* credential;
@property (copy) void(^responseHandler)(RESTResponse, NSDictionary*);

@end

@interface RESTParams : NSObject

@property NSDictionary* params;

- (instancetype)init;
- (instancetype) initWithDict: (NSDictionary*) params;
- (int) size;
- (BOOL) isEmpty;
- (void) addParam: (NSString*) param withValue: (id) value;
- (NSString*) toQueryString;

@end

@interface RESTClient : NSObject

+ (RESTClient*) instance;

@property (readonly) BOOL isInitialized;
@property (readonly) NSString* serverURL;
@property NSURLCredential* credentials;
@property NSString* basicAuth;
@property NSString* accessToken;

- initWithInfo: (NSDictionary*) dict;

- (void) setCredentialsWithUser:(NSString *)userName password:(NSString*) password;


/*- (void) doGETWithURL: (NSString*) path data: (RESTParams*) params handler: (NSObject<RESTResponseHandler>*) handler;
- (void) doGETWithURL: (NSString*) path absolute: (BOOL) abosolute data: (RESTParams*) params handler: (NSObject<RESTResponseHandler>*) handler;
- (void) doPOSTWithURL: (NSString*) path data: (RESTParams*) params handler: (NSObject<RESTResponseHandler>*) handler;
- (void) doPUTWithURL: (NSString*) path data: (RESTParams*) params handler: (NSObject<RESTResponseHandler>*) handler;
*/

- (void) doPOSTWithURL: (NSString*) path params: (RESTParams*) params complete: (void(^)(RESTResponse, NSDictionary*)) handler;
- (void) doGETWithURL: (NSString*) path absolute: (BOOL) absolute params: (RESTParams*) params complete: (void(^)(RESTResponse, NSDictionary*)) handler;
- (void) doGETWithURL: (NSString*) path params: (RESTParams*) params complete: (void(^)(RESTResponse, NSDictionary*)) handler;
- (void) doPUTWithURL: (NSString*) path params: (RESTParams*) params complete: (void(^)(RESTResponse, NSDictionary*)) handler;

- (void) doPOSTWithURL: (NSString*) path data: (NSJSONSerialization*) json complete: (void(^)(RESTResponse, NSDictionary*)) handler;
- (void) doPUTWithURL: (NSString*) path data: (NSJSONSerialization*) json complete: (void(^)(RESTResponse, NSDictionary*)) handler;

@end
