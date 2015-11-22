//
//  BBHUtil.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/27/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "BBHView.h"

#ifndef BBHUtil_h
#define BBHUtil_h

@interface BBHUtil : NSObject

+(NSDateFormatter*) dateScan;
+(NSDateFormatter*) dateFormat;
+(CGSize) statusBarSize;
+(CGFloat) statusBarHeight;
+(BOOL) isNull: (id) obj;
+(BOOL) isEmpty: (NSString*) string;
+(UIColor*) headerTextColor;

+(void) showConfirmSave: (UIViewController*)vc handler: (void (^)(ConfirmResponse)) handler;
+(void) showValidationAlert:(UIViewController *)vc field: (NSString*) fieldName;

+(UILabel*) makeLabelWithText: (NSString*)text frame:(CGRect)rect;
+(UILabel*) makeLabelWithText: (NSString*)text;
+(UITextField*) makeTextFieldWithText: (NSString*)text frame: (CGRect)rect;
+(UITextField*) makeTextFieldWithText: (NSString*)text;
+(CGSize) textSizeForLabel:(UILabel*) label;

+(CGSize) makeStack: (NSArray*) views superview: (UIView*) superView offset: (CGPoint) offset;
+(void) makeStackEdit: (NSArray*) views superview: (UIView*) superView offset: (CGPoint) offset;

+(NSNumber*) readDecimal: (NSString*) string;
+(NSNumber*) readInteger: (NSString*) string;

@end

#endif /* BBHUtil_h */
