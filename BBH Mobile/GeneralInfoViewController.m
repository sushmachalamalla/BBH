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

-(void)viewDidLoad {
    
    [self toggleWait:YES];
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[[[[self runEntity] links] objectForKey:@"self"] href] absolute:YES params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@"%@", data);
            [self setRunEntity:[[self runEntity] initWithDict:data]];
            
            [self makeUI];
            [self toggleWait:NO];
        }
    }];
}

-(void) makeUI {
    
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
}

-(void)success:(NSDictionary *)data {
    
    NSLog(@"%@", data);
    [self setRunEntity:[[self runEntity] initWithDict:data]];
    
    [self makeUI];
    [self toggleWait:NO];
}

- (void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    //
}

-(void)progress:(NSNumber *)percent {
    //
}

@end