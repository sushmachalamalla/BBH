//
//  TimeCardViewCell.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/8/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef BBH_Mobile_TimeCardViewCell_h
#define BBH_Mobile_TimeCardViewCell_h

@interface TimeCardViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *approvedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *approvedDateLabel;

@end

#endif
