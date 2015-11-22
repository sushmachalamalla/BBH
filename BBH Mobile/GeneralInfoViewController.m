//
//  RunInfoViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/2/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralInfoViewController.h"


@implementation GeneralInfoViewController

- (void) toggleWait: (BOOL) show {
    
    if(show) {
        
        [[self loadingIndicator] startAnimating];
        [[self loadingIndicator] setHidden:NO];
        
    } else {
        
        [[self loadingIndicator] stopAnimating];
        [[self loadingIndicator] setHidden:YES];
    }
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"General" image:nil tag:10];
        [self setTabBarItem:tabBarItem];
    }
    
    return self;
}

-(void)loadView {
    
    [super loadView];
}

-(void)viewDidLoad {
    
    [self makeUI];
    [self toggleWait:YES];
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[[[[self runEntity] links] objectForKey:@"self"] href] absolute:YES params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        NSLog(@">> RESPONSE (General Info): %@", data);
        if(response == RESTResponseSuccess) {
            
            [self setRunEntity:[[self runEntity] initWithDict:data]];
            [self toggleWait:NO];
            [self populate];
        }
    }];
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    UIView* contentView = [[[self scrollView] subviews] objectAtIndex:0];
    NSLog(@"%.2f, %.2f", [contentView frame].size.width, [contentView frame].size.height);
}

-(void)viewWillLayoutSubviews {
    
    //[[self view] setNeedsUpdateConstraints];
    [super viewWillLayoutSubviews];
}

-(void)updateViewConstraints {
    
    //NSLog(@">> Update Contraints ....");
    
    //[[self scrollView] setBackgroundColor:[UIColor redColor]];
    [[self scrollView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo([self view].mas_left);
        make.top.equalTo([self view].mas_top);
        make.right.equalTo([self view].mas_right);
        make.bottom.equalTo([self view].mas_bottom);
    }];
    
    UIView* contentView = (UIView*)[[[self scrollView] subviews] objectAtIndex:0];
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo([self scrollView].mas_left);
        make.top.equalTo([self scrollView].mas_top);
        make.right.equalTo([self scrollView].mas_right);
        make.bottom.equalTo([self scrollView].mas_bottom);
    }];
    
    NSArray* array = [NSArray arrayWithObjects:[self companyKeyLabel], [self runTitleKeyLabel], [self runNoKeyLabel], [self estPayKeyLabel], [self statusKeyLabel], [self driverTypeKeyLabel], [self driverClassKeyLabel], [self loadDescKeyLabel], nil];
    
    CGPoint offset = CGPointMake(5.0, 5.0);
    CGSize box = CGSizeMake(0.0, 0.0);
    
    box = [BBHUtil makeStack:array superview:contentView offset:offset];
    //NSLog(@">> box-1: %.2f, %.2f", box.width, box.height);
    
    offset.x = box.width + 5.0;
    array = [NSArray arrayWithObjects:[self companyLabel], [self runTitleLabel], [self runNoLabel], [self estPayLabel], [self statusLabel], [self driverTypeLabel], [self driverClassLabel], [self loadDescLabel], nil];
    
    box = [BBHUtil makeStack:array superview:contentView offset:offset];
    //NSLog(@">> box-2: %.2f, %.2f", box.width, box.height);
    
    [[self pickupAddrView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self loadDescLabel].mas_bottom).with.offset(10.0);
        make.left.equalTo(contentView.mas_left).with.offset(5.0);
    }];
    
    array = [NSArray arrayWithObjects:[self pickupKeyLabel], [self pickupDateLabel], [self pickupStreetAddrLabel], [self pickupCityLabel], [self pickupZipCodeLabel], [self pickupStateCountryLabel], nil];
    
    offset.x = 5.0;
    offset.y = 5.0;
    
    box = [BBHUtil makeStack:array superview:[self pickupAddrView] offset:offset];
    //NSLog(@">> box-3: %.2f, %.2f", box.width, box.height);
    
    [[self pickupAddrView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo([self pickupStateCountryLabel].mas_bottom).with.offset(5.0);
        make.right.equalTo(contentView.mas_left).with.offset(5.0 + box.width + offset.x);
    }];
    
    [[self dropAddrView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self pickupAddrView].mas_top);
        make.left.equalTo([self pickupAddrView].mas_right).with.offset(5.0);
        //make.right.equalTo(contentView.mas_right).with.offset(5.0);
        //make.width.greaterThanOrEqualTo([self pickupAddrView].mas_width);
    }];
    
    array = [NSArray arrayWithObjects:[self dropKeyLabel], [self dropDateLabel], [self dropStreetAddrLabel], [self dropCityLabel], [self dropZipCodeLabel], [self dropStateCountryLabel], nil];
    
    box = [BBHUtil makeStack:array superview:[self dropAddrView] offset:offset];
    //NSLog(@">> box-4: %.2f, %.2f", box.width, box.height);
    
    [[self dropAddrView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo([self pickupAddrView].mas_right).with.offset(5.0 + box.width + offset.x);
        make.bottom.equalTo([self dropStateCountryLabel].mas_bottom).with.offset(5.0);
    }];
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo([self dropAddrView].mas_right).with.offset(5.0);
        make.bottom.equalTo([self pickupAddrView].mas_bottom).with.offset(10.0);
    }];
    
    /*[[self loadingIndicator] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        //make.centerX.equalTo([self view].mas_centerX);
        //make.centerY.equalTo([self view].mas_centerY);
    }];*/
    
    [super updateViewConstraints];
}

-(void) makeUI {
    
    UIView* contentView = [[UIView alloc] init];
    
    [self setCompanyKeyLabel:[BBHUtil makeLabelWithText:@"Company"]];
    [self setRunTitleKeyLabel:[BBHUtil makeLabelWithText:@"Title"]];
    [self setRunNoKeyLabel:[BBHUtil makeLabelWithText:@"Run No"]];
    [self setEstPayKeyLabel:[BBHUtil makeLabelWithText:@"Est Pay"]];
    [self setStatusKeyLabel:[BBHUtil makeLabelWithText:@"Status"]];
    [self setDriverTypeKeyLabel:[BBHUtil makeLabelWithText:@"Driver Type"]];
    [self setDriverClassKeyLabel:[BBHUtil makeLabelWithText:@"Driver Class"]];
    [self setLoadDescKeyLabel:[BBHUtil makeLabelWithText:@"Load Desc"]];
    
    [self setCompanyLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setRunTitleLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setRunNoLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setEstPayLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setStatusLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setDriverTypeLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setDriverClassLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setLoadDescLabel:[BBHUtil makeLabelWithText:@"-"]];
    
    [contentView addSubview:[self companyKeyLabel]];
    [contentView addSubview:[self companyLabel]];
    
    [contentView addSubview:[self runTitleKeyLabel]];
    [contentView addSubview:[self runTitleLabel]];
    
    [contentView addSubview:[self runNoKeyLabel]];
    [contentView addSubview:[self runNoLabel]];
    
    [contentView addSubview:[self estPayKeyLabel]];
    [contentView addSubview:[self estPayLabel]];
    
    [contentView addSubview:[self statusKeyLabel]];
    [contentView addSubview:[self statusLabel]];
    
    [contentView addSubview:[self driverTypeKeyLabel]];
    [contentView addSubview:[self driverTypeLabel]];
    
    [contentView addSubview:[self driverClassKeyLabel]];
    [contentView addSubview:[self driverClassLabel]];
    
    [contentView addSubview:[self loadDescKeyLabel]];
    [contentView addSubview:[self loadDescLabel]];
    
    [self setPickupAddrView:[[UIView alloc] init]];
    [[self pickupAddrView] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [[self pickupAddrView] setOpaque:YES];
    
    [self setPickupKeyLabel:[BBHUtil makeLabelWithText:@"Pickup:"]];
    [[self pickupKeyLabel] setTextColor:[BBHUtil headerTextColor]];
    
    [self setPickupCityLabel: [BBHUtil makeLabelWithText:@"-"]];
    [self setPickupStateCountryLabel: [BBHUtil makeLabelWithText:@"-"]];
    [self setPickupDateLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setPickupStreetAddrLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setPickupZipCodeLabel:[BBHUtil makeLabelWithText:@"-"]];
    
    [[self pickupAddrView] addSubview:[self pickupKeyLabel]];
    [[self pickupAddrView] addSubview:[self pickupDateLabel]];
    [[self pickupAddrView] addSubview:[self pickupStreetAddrLabel]];
    [[self pickupAddrView] addSubview:[self pickupCityLabel]];
    [[self pickupAddrView] addSubview:[self pickupZipCodeLabel]];
    [[self pickupAddrView] addSubview:[self pickupStateCountryLabel]];
    
    [contentView addSubview:[self pickupAddrView]];
    
    [self setDropAddrView:[[UIView alloc] init]];
    [[self dropAddrView] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [[self dropAddrView] setOpaque:YES];
    
    [self setDropKeyLabel:[BBHUtil makeLabelWithText:@"Drop:"]];
    [[self dropKeyLabel] setTextColor:[BBHUtil headerTextColor]];
    
    [self setDropCityLabel: [BBHUtil makeLabelWithText:@"-"]];
    [self setDropStateCountryLabel: [BBHUtil makeLabelWithText:@"-"]];
    [self setDropDateLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setDropStreetAddrLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setDropZipCodeLabel:[BBHUtil makeLabelWithText:@"-"]];
    
    [[self dropAddrView] addSubview:[self dropKeyLabel]];
    [[self dropAddrView] addSubview:[self dropDateLabel]];
    [[self dropAddrView] addSubview:[self dropStreetAddrLabel]];
    [[self dropAddrView] addSubview:[self dropCityLabel]];
    [[self dropAddrView] addSubview:[self dropZipCodeLabel]];
    [[self dropAddrView] addSubview:[self dropStateCountryLabel]];
    
    [contentView addSubview:[self dropAddrView]];
    
    [self setScrollView:[[UIScrollView alloc] init]];
    [[self scrollView] setScrollEnabled:YES];
    [[self scrollView] setPagingEnabled:NO];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [[self scrollView] addSubview:contentView];
    [[self view] addSubview:[self scrollView]];
}

-(void) populate {
    
    Run* run = [self runEntity];
    
    NSString* clientName = [BBHUtil isNull:[run client]] ? @"N/A" : [[run client] clientName];
    NSString* title = [BBHUtil isNull:[run runTitle]] ? @"N/A" : [run runTitle];
    NSString* runNo = [BBHUtil isNull:[run runNumber]] ? @"N/A" : [run runNumber];
    NSString* estPay = [BBHUtil isNull:[run estimatedCost]] ? @"N/A" : [NSString stringWithFormat:@"%.2f", [[run estimatedCost] doubleValue]];
    NSString* status = [BBHUtil isNull:[run runStatus]] ? @"N/A" : [[run runStatus] runStatusName];
    NSString* driverType = [BBHUtil isNull:[run driverType]] ? @"N/A" : [[run driverType] driverTypeName];
    NSString* driverClass = [BBHUtil isNull:[run driverClass]] ? @"N/A" : [[run driverClass] driverClassName];
    NSString* loadDesc = [BBHUtil isNull:[run loadDescription]] ? @"N/A" : [run loadDescription];
    
    NSString* pickupDate = [BBHUtil isNull:[run runStartDate]] ? @"N/A" : [[BBHUtil dateFormat] stringFromDate:[run runStartDate]];
    
    Address* pickupAddr = [run pickupAddress];
    NSString* pickupStreetAddr = @"N/A";
    NSString* pickupCity = @"N/A";
    NSString* pickupZipCode = @"N/A";
    NSString* pickupStateCountry = @"N/A";
    
    if(![BBHUtil isNull:pickupAddr]) {
        
        pickupStreetAddr = [BBHUtil isNull:[pickupAddr address1]] ? @"N/A" : [pickupAddr address1];
        pickupCity = [BBHUtil isNull:[pickupAddr city]] ? @"N/A" : [pickupAddr city];
        pickupZipCode = [BBHUtil isNull:[pickupAddr zipCode]] ? @"N/A" : [pickupAddr zipCode];
        
        NSString* pickupCountryName = [BBHUtil isNull:[pickupAddr country]] ? @"N/A" : [[pickupAddr country] countryName];
        NSString* pickupStateCode = [BBHUtil isNull:[pickupAddr stateCode]] ? @"N/A" : [pickupAddr stateCode];
        
        pickupStateCountry = [BBHUtil isNull:pickupAddr] ? @"N/A" : [NSString stringWithFormat:@"%@, %@", pickupStateCode, pickupCountryName];
    }
    
    NSString* dropDate = [BBHUtil isNull:[run runEndDate]] ? @"N/A" : [[BBHUtil dateFormat] stringFromDate:[run runEndDate]];
    
    Address* dropAddr = [run dropOffAddress];
    NSString* dropStreetAddr = @"N/A";
    NSString* dropCity = @"N/A";
    NSString* dropZipCode = @"N/A";
    NSString* dropStateCountry = @"N/A";
    
    if(![BBHUtil isNull:dropAddr]) {
        
        dropStreetAddr = [BBHUtil isNull:[dropAddr address1]] ? @"N/A" : [dropAddr address1];
        dropCity = [BBHUtil isNull:[dropAddr city]] ? @"N/A" : [dropAddr city];
        dropZipCode = [BBHUtil isNull:[dropAddr zipCode]] ? @"N/A" : [dropAddr zipCode];
        
        NSString* dropCountryName = [BBHUtil isNull:[dropAddr country]] ? @"N/A" : [[dropAddr country] countryName];
        NSString* dropStateCode = [BBHUtil isNull:[dropAddr stateCode]] ? @"N/A" : [dropAddr stateCode];
        
        dropStateCountry = [BBHUtil isNull:dropAddr] ? @"N/A" : [NSString stringWithFormat:@"%@, %@", dropStateCode, dropCountryName];
    }
    
    [[self companyLabel] setText:clientName];
    [[self runTitleLabel] setText:title];
    [[self runNoLabel] setText:runNo];
    [[self estPayLabel] setText:estPay];
    [[self statusLabel] setText:status];
    [[self driverTypeLabel] setText:driverType];
    [[self driverClassLabel] setText:driverClass];
    [[self loadDescLabel] setText:loadDesc];
    
    [[self pickupDateLabel] setText:pickupDate];
    [[self pickupStreetAddrLabel] setText:pickupStreetAddr];
    [[self pickupCityLabel] setText:pickupCity];
    [[self pickupZipCodeLabel] setText:pickupZipCode];
    [[self pickupStateCountryLabel] setText:pickupStateCountry];
    
    [[self dropDateLabel] setText:dropDate];
    [[self dropStreetAddrLabel] setText:dropStreetAddr];
    [[self dropCityLabel] setText:dropCity];
    [[self dropZipCodeLabel] setText:dropZipCode];
    [[self dropStateCountryLabel] setText:dropStateCountry];
    
    [[self view] setNeedsUpdateConstraints];
}

-(void)success:(NSDictionary *)data {
    
    //
}

- (void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    //
}

-(void)progress:(NSNumber *)percent {
    //
}

@end