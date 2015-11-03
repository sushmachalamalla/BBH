//
//  BBHUtil.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/27/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBHUtil.h"

@implementation BBHUtil

static NSDateFormatter* dateScan;
static NSDateFormatter* dateFormat;
//static SysUser* sysUser;
static UIColor* headerTextColor;

+ (NSDateFormatter *)dateScan {
    
    if(!dateScan) {
        
        dateScan = [[NSDateFormatter alloc] init];
        [dateScan setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    
    return dateScan;
}

+ (NSDateFormatter *)dateFormat {
    
    if(!dateFormat) {
        
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
    }
    
    return dateFormat;
}

+ (CGSize)statusBarSize {
    
    return [[UIApplication sharedApplication] statusBarFrame].size;
}

+ (CGFloat)statusBarHeight {
    
    return MIN([self statusBarSize].width, [self statusBarSize].height);
}

+ (BOOL) isNull: (id) obj {
    
    return !obj || (obj == (id) [NSNull null]);
}

+(BOOL)isEmpty:(NSString *)string {
    
    return [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0;
}

+(UIColor *)headerTextColor {
    
    if(!headerTextColor) {
        
        headerTextColor = [UIColor colorWithRed:(59.0/255.0) green:(99.0/255.0) blue:(175.0/255.0) alpha:1.0];
    }
    
    return headerTextColor;
}

+(void) showAlert:(UIViewController *)vc handler: (void (^)(ConfirmResponse)) handler {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Save Changes ?" message:@"If you choose to proceed, any unsaved changes would be lost. Save changes before proceeding ?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        handler(ConfirmResponseSave);
    }];
    
    UIAlertAction* discardAction = [UIAlertAction actionWithTitle:@"Discard" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        handler(ConfirmResponseDiscard);
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        handler(ConfirmResponseCancel);
    }];
    
    [alert addAction:saveAction];
    [alert addAction:discardAction];
    [alert addAction:cancelAction];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

+(UILabel*) makeLabelWithText: (NSString*)text frame:(CGRect)rect {
    
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    [label setText:text];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    
    return label;
}

+(UITextField*) makeTextFieldWithText: (NSString*)text frame: (CGRect)rect {
    
    UITextField* tf = [[UITextField alloc] initWithFrame:rect];
    
    if (text) {
        [tf setPlaceholder:text];
    }
    
    [tf setBorderStyle:UITextBorderStyleRoundedRect];
    
    return tf;
}

@end
