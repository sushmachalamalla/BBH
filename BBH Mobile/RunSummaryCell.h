//
//  RunSummaryCell.h
//  BBH Mobile
//
//  Created by Mac-Mini on 9/29/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "UIKit/uikit.h"

#ifndef BBH_Mobile_RunSummaryCell_h
#define BBH_Mobile_RunSummaryCell_h

@interface RunSummaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *runTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *estPayLabel;

@property (weak, nonatomic) IBOutlet UILabel *driverTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverClassLabel;

@property (weak, nonatomic) IBOutlet UILabel *pickupLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropLocationLabel;

@property (weak, nonatomic) IBOutlet UILabel *dropDateLabel;

@end
#endif
