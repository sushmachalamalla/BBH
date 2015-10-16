//
//  PaymentMethodViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/6/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "UIKit/uikit.h"
#import "Entities.h"
#import "RESTClient.h"

#ifndef BBH_Mobile_PaymentMethodViewController_h
#define BBH_Mobile_PaymentMethodViewController_h

@interface PaymentMethodViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, RESTResponseHandler>

@property NSMutableArray* content;
@property Run* runEntity;
@property (weak, nonatomic) IBOutlet UITableView *pmTableView;

@end

#endif
