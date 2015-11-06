//
//  RunSummaryCell.h
//  BBH Mobile
//
//  Created by Mac-Mini on 9/29/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "UIKit/uikit.h"
#import "Masonry/Masonry.h"
#import "BBHUtil.h"

#ifndef BBH_Mobile_RunSummaryCell_h
#define BBH_Mobile_RunSummaryCell_h

@interface RunSummaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *companyKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property (weak, nonatomic) IBOutlet UILabel *runTitleKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *runTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *estPayKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *estPayLabel;

@property (weak, nonatomic) IBOutlet UILabel *driverTypeKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *driverClassKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverClassLabel;

@property (weak, nonatomic) IBOutlet UILabel *pickupKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *dropKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropDateLabel;

@property (weak, nonatomic) IBOutlet UIView *pickupAddrView;
@property (weak, nonatomic) IBOutlet UIView *dropAddrView;

@end
#endif
