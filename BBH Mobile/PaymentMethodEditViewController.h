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

#ifndef PaymentMethodEditViewController_h
#define PaymentMethodEditViewController_h

@interface PaymentMethodEditViewController: PaymentMethodViewController<EditView>

/*@property NSMutableArray* content;
@property Run* runEntity;
@property (weak, nonatomic) IBOutlet UITableView *pmTableView;*/

@property UIViewController* editController;

@property UILabel* pmNameLabel;
@property UILabel* pmUnitLabel;
@property UILabel* pmCostLabel;

@property UITextField* pmNameTF;
@property UITextField* pmUnitTF;
@property UITextField* pmCostTF;

@end

#endif /* PaymentMethodEditViewController_h */
