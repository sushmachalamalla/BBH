//
//  GeneralInfoEditViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/14/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entities.h"
#import "RESTClient.h"
#import "PickerDelegate.h"

#ifndef BBH_Mobile_GeneralInfoEditViewController_h
#define BBH_Mobile_GeneralInfoEditViewController_h

@interface GeneralInfoEditViewController : UIViewController<RESTResponseHandler, UIScrollViewDelegate>

@property Run* runEntity;
@property PickerDelegate* driverTypeDelegate;
@property PickerDelegate* frequencyDelegate;
@property PickerDelegate* driverClassDelegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

#endif
