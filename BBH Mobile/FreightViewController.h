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

@property (strong, nonatomic) UILabel *totalWeightKeyLabel;
@property (strong, nonatomic) UILabel *deliveryKeyLabel;
@property (strong, nonatomic) UILabel *freightLoadingKeyLabel;
@property (strong, nonatomic) UILabel *freightDescriptionKeyLabel;
@property (strong, nonatomic) UILabel *lumperFeeKeyLabel;
@property (strong, nonatomic) UILabel *lumperFeeAmountKeyLabel;
@property (strong, nonatomic) UILabel *detentionFeeKeyLabel;
@property (strong, nonatomic) UILabel *fuelAdvanceKeyLabel;
@property (strong, nonatomic) UILabel *tonuKeyLabel;
@property (strong, nonatomic) UILabel *driverAssistanceKeyLabel;
@property (strong, nonatomic) UILabel *dockFacilityKeyLabel;
@property (strong, nonatomic) UILabel *scaleTicketsKeyLabel;
@property (strong, nonatomic) UILabel *billOfLadingKeyLabel;
@property (strong, nonatomic) UILabel *sealOnTrailerKeyLabel;
@property (strong, nonatomic) UILabel *detentionFeeAmountKeyLabel;
@property (strong, nonatomic) UILabel *fuelAdvanceAmountKeyLabel;
@property (strong, nonatomic) UILabel *tonuPenaltyAmountKeyLabel;

@property (strong, nonatomic) UILabel *totalWeightLabel;
@property (strong, nonatomic) UILabel *deliveryLabel;
@property (strong, nonatomic) UILabel *freightLoadingLabel;
@property (strong, nonatomic) UILabel *freightDescriptionLabel;
@property (strong, nonatomic) UILabel *lumperFeeLabel;
@property (strong, nonatomic) UILabel *lumperFeeAmountLabel;
@property (strong, nonatomic) UILabel *detentionFeeLabel;
@property (strong, nonatomic) UILabel *fuelAdvanceLabel;
@property (strong, nonatomic) UILabel *tonuLabel;
@property (strong, nonatomic) UILabel *driverAssistanceLabel;
@property (strong, nonatomic) UILabel *dockFacilityLabel;
@property (strong, nonatomic) UILabel *scaleTicketsLabel;
@property (strong, nonatomic) UILabel *billOfLadingLabel;
@property (strong, nonatomic) UILabel *sealOnTrailerLabel;
@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) UILabel *detentionFeeAmountLabel;
@property (strong, nonatomic) UILabel *fuelAdvanceAmountLabel;
@property (strong, nonatomic) UILabel *tonuPenaltyAmountLabel;

@property (strong, nonatomic) UIScrollView* scrollView;

@property Run* runEntity;

@end

#endif
