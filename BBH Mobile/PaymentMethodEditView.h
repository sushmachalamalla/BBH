//
//  PaymentMethodEditView.h
//  BBH Mobile
//
//  Created by Mac-Mini on 11/19/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBHUtil.h"
#import "Entities.h"
#import "RESTClient.h"
#import "PickerDelegate.h"

#ifndef PaymentMethodEditView_h
#define PaymentMethodEditView_h

@class PaymentMethodEditViewController;

@interface PaymentMethodEditView : UIViewController<BBHEditView>

@property UILabel* pmNameLabel;
@property UILabel* pmUnitLabel;
@property UILabel* pmCostLabel;

@property UIPickerView* pmPicker;
@property UITextField* pmUnitTF;
@property UITextField* pmCostTF;

@property PickerDelegate* pmDelegate;

//@property UIView* btnPanel;
//@property UIButton* saveBtn;
//@property UIButton* cancelBtn;

@property UIView* contentView;
@property RunPaymentMethod* pmEntity;
@property Run* runEntity;

@end

#endif /* PaymentMethodEditView_h */
