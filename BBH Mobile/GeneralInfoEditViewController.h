//
//  GeneralInfoEditViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/14/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entities.h"
#import "BBHUtil.h"
#import "RESTClient.h"
#import "PickerDelegate.h"

#ifndef BBH_Mobile_GeneralInfoEditViewController_h
#define BBH_Mobile_GeneralInfoEditViewController_h

@interface GeneralInfoEditViewController : UIViewController<RESTResponseHandler, UIScrollViewDelegate, BBHEditView>

@property Run* runEntity;
@property PickerDelegate* driverTypeDelegate;
@property PickerDelegate* frequencyDelegate;
@property PickerDelegate* driverClassDelegate;
@property PickerDelegate* pickupLocationTypeDelegate;
@property PickerDelegate* dropLocationTypeDelegate;

@property UILabel* runTitleLabel;
@property UITextField* runtTitleTF;
@property UILabel* driverTypeLabel;
@property UIPickerView* driverTypePicker;
@property UILabel* equipTypeLabel;
@property UITextField* equipTypeTF;
@property UILabel* trailerLabel;
@property UISwitch* trailerSwitch;
@property UILabel* teamRunLabel;
@property UISwitch* teamRunSwitch;
@property UILabel* recurringLabel;
@property UISwitch* recurringSwitch;
@property UILabel* freqLabel;
@property UIPickerView* freqPicker;
@property UILabel* driverClassLabel;
@property UIPickerView* driverClassPicker;
@property UILabel* loadDescLabel;
@property UITextField* loadDescTF;
@property UILabel* startDateLabel;
@property UIDatePicker* startDatePicker;
@property UILabel* endDateLabel;
@property UIDatePicker* endDatePicker;

@property UILabel* pickupLocLabel;

@property UILabel* pickupContactLabel;
@property UITextField* pickupContactTF;
@property UILabel* pickupContactPhoneLabel;
@property UITextField* pickupContactPhoneTF;
@property UILabel* pickupLocationTypeLabel;
@property UIPickerView* pickupLocationTypePicker;
@property UILabel* pickupStreetAddressLabel;
@property UITextField* pickupStreetAddressTF;
@property UILabel* pickupZipCodeLabel;
@property UITextField* pickupZipCodeTF;
@property UILabel* pickupCityLabel;
@property UITextField* pickupCityTF;
@property UILabel* pickupStateLabel;
@property UITextField* pickupStateTF;

@property UILabel* dropLocLabel;

@property UILabel* dropContactLabel;
@property UITextField* dropContactTF;
@property UILabel* dropContactPhoneLabel;
@property UITextField* dropContactPhoneTF;
@property UILabel* dropLocationTypeLabel;
@property UIPickerView* dropLocationTypePicker;
@property UILabel* dropStreetAddressLabel;
@property UITextField* dropStreetAddressTF;
@property UILabel* dropZipCodeLabel;
@property UITextField* dropZipCodeTF;
@property UILabel* dropCityLabel;
@property UITextField* dropCityTF;
@property UILabel* dropStateLabel;
@property UITextField* dropStateTF;

@property UILabel* spInstructionsLabel;
@property UITextField* spInstructionsTF;
@property UILabel* hiringCriteriaLabel;
@property UITextField* hiringCriteriaTF;
@property UILabel* criminalBGLabel;
@property UISwitch* criminalBGSwitch;

@property (strong, nonatomic) UIScrollView *scrollView;

@end

#endif
