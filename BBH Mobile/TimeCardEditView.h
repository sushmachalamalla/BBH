//
//  TimeCardEditView.h
//  BBH Mobile
//
//  Created by Mac-Mini on 11/24/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entities.h"
#import "BBHUtil.h"
#import "RESTClient.h"
#import "TimeCardExpenseCell.h"
#import "UIViewController+BBHVIewController.h"

#ifndef TimeCardEditView_h
#define TimeCardEditView_h

@interface TimeCardEditView : UIViewController<UITableViewDataSource, UITableViewDelegate, BBHEditView>

@property UILabel* startDateLabel;
@property UILabel* startTimeLabel;
@property UILabel* endDateLabel;
@property UILabel* endTimeLabel;

@property UIDatePicker* startDatePicker;
@property UIDatePicker* startTimePicker;
@property UIDatePicker* endDatePicker;
@property UIDatePicker* endTimePicker;

@property UITableView* expenseTableView;
@property UIView* contentView;

@property NSMutableArray* content;

@property Run* runEntity;
@property TimeCard* tcEntity;

@property UIBarButtonItem* addBtn;

@end

#endif /* TimeCardEditView_h */
