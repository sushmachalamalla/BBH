//
//  PaymentMethodEditViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 11/2/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTClient.h"
#import "Entities.h"
#import "BBHUtil.h"
#import "PaymentMethodViewController.h"
#import "PaymentMethodEditView.h"
#import "UIViewController+BBHVIewController.h"

#ifndef PaymentMethodEditViewController_h
#define PaymentMethodEditViewController_h

@interface PaymentMethodEditViewController: PaymentMethodViewController<BBHEditView>

@property PaymentMethodEditView* editController;
@property UIBarButtonItem* addBtn;

-(void)navStackPushedFrom:(UIViewController *)sourceVC;

@end

#endif /* PaymentMethodEditViewController_h */
