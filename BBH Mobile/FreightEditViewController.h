//
//  FreightEditViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/27/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entities.h"
#import "BBHUtil.h"
#import "RESTClient.h"
#import "PickerDelegate.h"

#ifndef FreightEditViewController_h
#define FreightEditViewController_h

@interface FreightEditViewController : UIViewController<UIScrollViewDelegate,RESTResponseHandler,EditView>

@property Run* runEntity;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property PickerDelegate* deliveryDelegate;
@property PickerDelegate* freightLoadingDelegate;

@property UILabel *totalWeightLabel;
@property UILabel *deliveryLabel;
@property UILabel *freightLoadingLabel;
@property UILabel *freightDescriptionLabel;
@property UILabel *lumperFeeLabel;
@property UILabel *lumperFeeAmountLabel;
@property UILabel *detentionFeeLabel;
@property UILabel *detentionFeeAmountLabel;
@property UILabel *fuelAdvanceLabel;
@property UILabel *fuelAdvanceAmountLabel;
@property UILabel *tonuLabel;
@property UILabel *tonuPenaltyAmountLabel;
@property UILabel *driverAssistanceLabel;
@property UILabel *dockFacilityLabel;
@property UILabel *scaleTicketsLabel;
@property UILabel *billOfLadingLabel;
@property UILabel *sealOnTrailerLabel;

@property UITextField *totalWeightTF;
@property UIPickerView *deliveryPicker;
@property UIPickerView *freightLoadingPicker;
@property UITextField *freightDescriptionTF;
@property UISwitch *lumperFeeSwitch;
@property UITextField *lumperFeeAmountTF;
@property UISwitch *detentionFeeSwitch;
@property UITextField *detentionFeeAmountTF;
@property UISwitch *fuelAdvanceSwitch;
@property UITextField *fuelAdvanceAmountTF;
@property UISwitch *tonuSwitch;
@property UITextField *tonuPenaltyAmountTF;
@property UISwitch *driverAssistanceSwitch;
@property UISwitch *dockFacilitySwitch;
@property UISwitch *scaleTicketsSwitch;
@property UISwitch *billOfLadingSwitch;
@property UISwitch *sealOnTrailerSwitch;
@property UIActivityIndicatorView *loadingIndicator;

@end

#endif /* FreightEditViewController_h */
