//
//  FreightViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/4/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//


#import "UIKit/uikit.h"
#import "Entities.h"
#import "RESTClient.h"

#ifndef BBH_Mobile_FreightViewController_h
#define BBH_Mobile_FreightViewController_h

@interface FreightViewController : UIViewController<RESTResponseHandler>

@property (weak, nonatomic) IBOutlet UILabel *totalWeightLabel;

@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLoadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *lumperFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lumperFeeAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *detentionFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuelAdvanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tonuLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverAssistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dockFacilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *scaleTicketsLabel;
@property (weak, nonatomic) IBOutlet UILabel *billOfLadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *sealOnTrailerLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *detentionFeeAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuelAdvanceAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tonuPenaltyAmountLabel;

@property Run* runEntity;

@end

#endif
