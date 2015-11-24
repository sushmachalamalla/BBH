//
//  TimeCardViewCell.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/8/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry/Masonry.h"
#import "BBHUtil.h"


#ifndef BBH_Mobile_TimeCardViewCell_h
#define BBH_Mobile_TimeCardViewCell_h

@interface TimeCardViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameKeyLabel;
@property (strong, nonatomic) UILabel *statusKeyLabel;
@property (strong, nonatomic) UILabel *approvedByKeyLabel;
@property (strong, nonatomic) UILabel *approvedDateKeyLabel;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UILabel *approvedByLabel;
@property (strong, nonatomic) UILabel *approvedDateLabel;

@end

#endif
