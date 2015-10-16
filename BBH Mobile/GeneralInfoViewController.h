//
//  RunInfoViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/2/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "UIKit/uikit.h"
#import "Entities.h"
#import "RESTClient.h"

#ifndef BBH_Mobile_RunInfoViewController_h
#define BBH_Mobile_RunInfoViewController_h

@interface GeneralInfoViewController : UIViewController<RESTResponseHandler>

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *runTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *runNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *estPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *driverTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverClassLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadDescLabel;

@property (weak, nonatomic) IBOutlet UILabel *pickupDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupStreetAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupZipCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupStateCountryLabel;

@property (weak, nonatomic) IBOutlet UILabel *dropDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropStreetAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropZipCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropStateCountryLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property Run* runEntity;

@end

#endif
