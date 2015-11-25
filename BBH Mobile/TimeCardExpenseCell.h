//
//  TimeCardDateCell.h
//  BBH Mobile
//
//  Created by Mac-Mini on 11/25/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entities.h"
#import "RESTClient.h"
#import "BBHUtil.h"
#import "UIViewController+BBHVIewController.h"

#ifndef TimeCardDateCell_h
#define TimeCardDateCell_h

@interface TimeCardExpenseCell : UITableViewCell<BBHView>

@property UILabel* nameLabel;
@property UILabel* estAmtLabel;
@property UILabel* actualAmtLabel;

@end

#endif /* TimeCardDateCell_h */
