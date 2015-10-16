//
//  RunDetailViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/2/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "UIKit/uikit.h"
#import "Entities.h"
#import "GeneralInfoViewController.h"
#import "FreightViewController.h"
#import "PaymentMethodViewController.h"
#import "CriteriaViewController.h"
#import "TimeCardViewController.h"
#import "DriverViewController.h"
#import "RunDetailEditViewController.h"

#ifndef BBH_Mobile_RunDetailViewController_h
#define BBH_Mobile_RunDetailViewController_h

@interface RunDetailViewController : UITabBarController<UITabBarControllerDelegate, UITabBarDelegate>

@property Run* runEntity;

@end

#endif
