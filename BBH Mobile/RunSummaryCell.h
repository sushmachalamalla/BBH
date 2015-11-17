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

@property (strong, nonatomic) UILabel *companyKeyLabel;
@property (strong, nonatomic) UILabel *companyLabel;

@property (strong, nonatomic) UILabel *runTitleKeyLabel;
@property (strong, nonatomic) UILabel *runTitleLabel;

@property (strong, nonatomic) UILabel *estPayKeyLabel;
@property (strong, nonatomic) UILabel *estPayLabel;

@property (strong, nonatomic) UILabel *driverTypeKeyLabel;
@property (strong, nonatomic) UILabel *driverTypeLabel;

@property (strong, nonatomic) UILabel *driverClassKeyLabel;
@property (strong, nonatomic) UILabel *driverClassLabel;

@property (strong, nonatomic) UILabel *pickupKeyLabel;
@property (strong, nonatomic) UILabel *pickupLocationLabel;
@property (strong, nonatomic) UILabel *pickupDateLabel;

@property (strong, nonatomic) UILabel *dropKeyLabel;
@property (strong, nonatomic) UILabel *dropLocationLabel;
@property (strong, nonatomic) UILabel *dropDateLabel;

@property (strong, nonatomic) UIView *pickupAddrView;
@property (strong, nonatomic) UIView *dropAddrView;

@end
#endif
