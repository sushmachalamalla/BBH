//
//  BBHUtil.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/27/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

#ifndef BBHUtil_h
#define BBHUtil_h

typedef NS_ENUM(NSInteger, EntityMode) {
    
    EntityModeAdd, EntityModeEdit, EntityModeView
};

typedef NS_ENUM(NSInteger, ConfirmResponse) {
    
    ConfirmResponseSave, ConfirmResponseDiscard, ConfirmResponseCancel
};

@protocol EditView <NSObject>

@property EntityMode mode;

-(void) confirmSave: (void (^)(ConfirmResponse)) handler;
-(void) saveInfo;

@end

@interface StackElt : NSObject

@property UIView* last;
@property CGPoint bottomRight;

@end

@interface BBHUtil : NSObject

+(NSDateFormatter*) dateScan;
+(NSDateFormatter*) dateFormat;
+(CGSize) statusBarSize;
+(CGFloat) statusBarHeight;
+(BOOL) isNull: (id) obj;
+(BOOL) isEmpty: (NSString*) string;
+(UIColor*) headerTextColor;
+(void) showAlert: (UIViewController*)vc handler: (void (^)(ConfirmResponse)) handler;
+(UILabel*) makeLabelWithText: (NSString*)text frame:(CGRect)rect;
+(UILabel*) makeLabelWithText: (NSString*)text;
+(UITextField*) makeTextFieldWithText: (NSString*)text frame: (CGRect)rect;
+(UITextField*) makeTextFieldWithText: (NSString*)text;
+(CGSize) textSizeForLabel:(UILabel*) label;
+(CGSize) makeStack: (NSArray*) views superview: (UIView*) superView offset: (CGPoint) offset;
+(void) makeStackEdit: (NSArray*) views superview: (UIView*) superView offset: (CGPoint) offset;

@end

#endif /* BBHUtil_h */
