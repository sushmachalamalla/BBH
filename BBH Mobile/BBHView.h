//
//  BBHView.h
//  BBH Mobile
//
//  Created by Mac-Mini on 11/19/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BBHVIewController.h"

#ifndef BBHView_h
#define BBHView_h

typedef NS_ENUM(NSInteger, EntityMode) {
    
    EntityModeAdd, EntityModeEdit, EntityModeView
};

typedef NS_ENUM(NSInteger, ConfirmResponse) {
    
    ConfirmResponseSave, ConfirmResponseDiscard, ConfirmResponseCancel
};

@protocol BBHView <NSObject>

@property BOOL isUIDone;

-(void) makeUI;

@optional
-(void) populate;
-(void) populate: (id) entity;
-(void) fetchData;
-(void) fetchData: (int) pageNo;

@end

@protocol BBHEditView <BBHView>

@property EntityMode mode;
@property BOOL isClean;

-(void) confirmSave: (void (^)(ConfirmResponse)) handler;
-(void) saveInfo;

@end

#endif /* BBHView_h */
