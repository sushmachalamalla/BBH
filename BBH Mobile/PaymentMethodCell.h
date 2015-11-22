//
//  PaymentMethodCell.h
//  BBH Mobile
//
//  Created by Mac-Mini on 11/18/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry/Masonry.h"
#import "BBHUtil.h"

#ifndef PaymentMethodCell_h
#define PaymentMethodCell_h

@interface PaymentMethodCell : UITableViewCell

@property UILabel* pmLabel;
@property UILabel* unitLabel;
@property UILabel* rateLabel;

@end

#endif /* PaymentMethodCell_h */
