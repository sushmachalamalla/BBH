//
//  TimeCardViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/8/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entities.h"
#import "RESTClient.h"
#import "TimeCardViewCell.h"
#import "UIViewController+BBHVIewController.h"

#ifndef BBH_Mobile_TimeCardViewController_h
#define BBH_Mobile_TimeCardViewController_h

@interface TimeCardViewController : UIViewController<RESTResponseHandler, UITableViewDataSource, UITableViewDelegate, BBHView>

@property Run* runEntity;
@property NSMutableArray* content;

@property UITableView* tcTableView;

@end

#endif
