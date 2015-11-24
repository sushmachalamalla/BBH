//
//  CriteriaEditView.h
//  BBH Mobile
//
//  Created by Mac-Mini on 11/22/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entities.h"
#import "BBHUtil.h"
#import "RESTClient.h"
#import "PickerDelegate.h"
#import "CriteriaViewController.h"
#import "UIViewController+BBHVIewController.h"

#ifndef CriteriaEditView_h
#define CriteriaEditView_h

@interface CriteriaEditView : UIViewController<BBHEditView>

@property UILabel* skillLabel;
@property UILabel* yearSlotLabel;

@property UIPickerView* skillPicker;
@property UIPickerView* yearSlotPicker;

@property PickerDelegate* skillDelegate;
@property PickerDelegate* experienceDelegate;

@property UIView* contentView;

@property CriteriaTable tableType;

@property RunEquipmentSkill* skillEntity;
@property Run* runEntity;

@end

#endif /* CriteriaEditView_h */
