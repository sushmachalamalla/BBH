//
//  CriteriaCell.h
//  BBH Mobile
//
//  Created by Mac-Mini on 11/22/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entities.h"
#import "BBHUtil.h"

#ifndef CriteriaCell_h
#define CriteriaCell_h

@interface EndorsementCell: UITableViewCell

@property UILabel* endorsementLabel;

@end

@interface EquipmentCell: UITableViewCell

@property UILabel* equipmentLabel;
@property UILabel* yearSlotLabel;

@end

@interface SkillCell: UITableViewCell

@property UILabel* skillLabel;
@property UILabel* yearSlotLabel;

@end

#endif /* CriteriaCell_h */
