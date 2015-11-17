//
//  BBHUtil.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/27/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBHUtil.h"

@implementation StackElt



@end

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
    
    return [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
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
    
    UILabel* label = CGRectIsNull(rect) ? [[UILabel alloc] init] : [[UILabel alloc] initWithFrame:rect];
    //[label setText:([BBHUtil isEmpty: text] ? @" " : text)];
    [label setText:text];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    
    return label;
}

+(UILabel*) makeLabelWithText: (NSString*)text {
    
    return [BBHUtil makeLabelWithText:text frame:CGRectNull];
}

+(UITextField*) makeTextFieldWithText: (NSString*)text frame: (CGRect)rect {
    
    UITextField* tf = [[UITextField alloc] initWithFrame:rect];
    
    if (text) {
        [tf setPlaceholder:text];
    }
    
    [tf setBorderStyle:UITextBorderStyleRoundedRect];
    
    return tf;
}

+(UITextField*) makeTextFieldWithText: (NSString*)text {
    
    return [BBHUtil makeTextFieldWithText:text frame:CGRectNull];
}

+(CGSize)textSizeForLabel:(UILabel *)label {
    
    return [[label text] sizeWithAttributes:@{NSFontAttributeName:[label font]}];
}

/*+(CGPoint) makeColumn: (NSArray*)items withOrig: (CGPoint) orig superview: (UIView*)view {
    
    //CGPoint viewOrig = [view frame].origin;
    //__block CGPoint curOrig = CGPointMake(viewOrig.x + orig.x, viewOrig.y + orig.y);
    __block float maxRight = 0.0;
    __block UIView* last = nil;
    
    UIFont* textFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel* label = (UILabel*) obj;
        
        [label setFont:textFont];
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(view.mas_left).with.offset(orig.x);
            
            if(last) {
                make.top.equalTo(last.mas_bottom).with.offset(10.0);
            } else {
                make.top.equalTo(view.mas_top).with.offset(orig.y);
            }
        }];
        
        last = label;
        maxRight = MAX(maxRight, [BBHUtil textSizeForLabel:label].width);
    }];
    
    return CGPointMake(orig.x + maxRight, orig.y + [last frame].origin.y + [last frame].size.height);
}*/

+(CGSize) makeStack: (NSArray*) views superview: (UIView*) superView offset: (CGPoint) offset {
    
    //UIFont* font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    __block UILabel* last = nil;
    __block CGFloat maxRight = 0.0;
    
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel* view = (UILabel*) obj;
        
        //[view setFont:font];
        
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(superView.mas_left).with.offset(offset.x);
            
            if(last) {
                make.top.equalTo(last.mas_bottom).with.offset(5.0);
            } else {
                make.top.equalTo(superView.mas_top).with.offset(offset.y);
            }
        }];
        
        last = view;
        //NSLog(@">>>>> MAX: %.2f", [BBHUtil textSizeForLabel:last].width);
        maxRight = MAX(maxRight, [BBHUtil textSizeForLabel:last].width);
    }];
    
    //NSLog(@">>>>> DONE");
    return CGSizeMake(offset.x + maxRight, ([last frame].origin.y + [last frame].size.height)-offset.y);
}

+(void) makeStackEdit: (NSArray*) views superview: (UIView*) superView offset: (CGPoint) offset {
    
    //UIFont* font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    __block UIView* last = nil;
    
    CGFloat labelWidth = 266.0;
    CGFloat labelHeight = 21.0;
    
    CGFloat tfWidth = 584.0;
    CGFloat tfHeight = 30.0;
    
    CGFloat pickerWidth = 300.0;
    CGFloat pickerHeight = 100.0;
    
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView* view = (UIView*) obj;
        CGFloat height = -1.0;
        
        if([view isKindOfClass:[UILabel class]]) {
            
            height = labelHeight;
            
        } else if([view isKindOfClass:[UITextField class]]) {
            
            height = tfHeight;
            
        } else if([view isKindOfClass: [UIPickerView class]] || [view isKindOfClass: [UIDatePicker class]]) {
            
            height = pickerHeight;
        }
        
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(superView.mas_left).with.offset(offset.x);
            make.right.equalTo(superView.mas_right).with.offset(offset.x);
            
            if(last) {
                make.top.equalTo(last.mas_bottom).with.offset(5.0);
            } else {
                make.top.equalTo(superView.mas_top).with.offset(offset.y);
            }
            
            if(height > 0.0) {
                
                make.height.mas_equalTo(height);
            }
        }];
        
        last = view;
    }];
}

@end
