//
//  RunDetailEditViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/12/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTClient.h"
#import "Entities.h"
#import "BBHUtil.h"
#import "GeneralInfoEditViewController.h"
#import "FreightEditViewController.h"
#import "PaymentMethodEditViewController.h"
#import "CriteriaEditViewController.h"
#import "TimeCardEditViewController.h"
#import "UIViewController+BBHVIewController.h"

#ifndef BBH_Mobile_RunDetailEditViewController_h
#define BBH_Mobile_RunDetailEditViewController_h

@interface RunDetailEditViewController : UITabBarController<UITabBarControllerDelegate>

@property Run* runEntity;
@property EntityMode mode;
@property BOOL isConfirmed;

@end

#endif
