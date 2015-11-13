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

@interface GeneralInfoViewController : UIViewController<RESTResponseHandler, UIScrollViewDelegate>

@property (strong, nonatomic) UILabel *companyKeyLabel;
@property (strong, nonatomic) UILabel *runTitleKeyLabel;
@property (strong, nonatomic) UILabel *runNoKeyLabel;
@property (strong, nonatomic) UILabel *estPayKeyLabel;
@property (strong, nonatomic) UILabel *statusKeyLabel;

@property (strong, nonatomic) UILabel *driverTypeKeyLabel;
@property (strong, nonatomic) UILabel *driverClassKeyLabel;
@property (strong, nonatomic) UILabel *loadDescKeyLabel;

/*@property (strong, nonatomic) UILabel *pickupDateKeyLabel;
@property (strong, nonatomic) UILabel *pickupStreetAddrKeyLabel;
@property (strong, nonatomic) UILabel *pickupCityKeyLabel;
@property (strong, nonatomic) UILabel *pickupZipCodeKeyLabel;
@property (strong, nonatomic) UILabel *pickupStateCountryKeyLabel;

@property (strong, nonatomic) UILabel *dropDateKeyLabel;
@property (strong, nonatomic) UILabel *dropStreetAddrKeyLabel;
@property (strong, nonatomic) UILabel *dropCityKeyLabel;
@property (strong, nonatomic) UILabel *dropZipCodeKeyLabel;
@property (strong, nonatomic) UILabel *dropStateCountryKeyLabel;*/

@property (strong, nonatomic) UILabel *companyLabel;
@property (strong, nonatomic) UILabel *runTitleLabel;
@property (strong, nonatomic) UILabel *runNoLabel;
@property (strong, nonatomic) UILabel *estPayLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@property (strong, nonatomic) UILabel *driverTypeLabel;
@property (strong, nonatomic) UILabel *driverClassLabel;
@property (strong, nonatomic) UILabel *loadDescLabel;

@property (strong, nonatomic) UIView *pickupAddrView;
@property (strong, nonatomic) UILabel * pickupKeyLabel;

@property (strong, nonatomic) UILabel *pickupDateLabel;
@property (strong, nonatomic) UILabel *pickupStreetAddrLabel;
@property (strong, nonatomic) UILabel *pickupCityLabel;
@property (strong, nonatomic) UILabel *pickupZipCodeLabel;
@property (strong, nonatomic) UILabel *pickupStateCountryLabel;

@property (strong, nonatomic) UIView *dropAddrView;
@property (strong, nonatomic) UILabel * dropKeyLabel;

@property (strong, nonatomic) UILabel *dropDateLabel;
@property (strong, nonatomic) UILabel *dropStreetAddrLabel;
@property (strong, nonatomic) UILabel *dropCityLabel;
@property (strong, nonatomic) UILabel *dropZipCodeLabel;
@property (strong, nonatomic) UILabel *dropStateCountryLabel;

@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) UIScrollView *scrollView;

@property Run* runEntity;

@end

#endif
