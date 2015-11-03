//
//  FreightViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/4/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FreightViewController.h"

@implementation FreightViewController

- (void) toggleWait: (BOOL) show {
    
    if(show) {
        
        [[self loadingIndicator] startAnimating];
        [[self loadingIndicator] setHidden:NO];
        
    } else {
        
        [[self loadingIndicator] stopAnimating];
        [[self loadingIndicator] setHidden:YES];
    }
}

-(void)makeUI {
    
    Run* run = [self runEntity];
    
    NSString* totalFreightWeight = [BBHUtil isNull:[run totalFreightWeight]] ? @"N/A" : [NSString stringWithFormat:@"%.2f", [[run totalFreightWeight] doubleValue]];
    
    NSString* delivery = [BBHUtil isNull:[run deliveryScheduleType]] ? @"N/A" : [[run deliveryScheduleType] deliveryScheduleTypeName];
    
    NSString* freightLoading = [BBHUtil isNull:[run loadingType]] ? @"N/A" : [[run loadingType] loadingTypeName];
    
    NSString* freightDesc = [BBHUtil isNull:[run freightDetails]] ? @"N/A" : [run freightDetails];
    
    NSString* lumperFee = [NSString stringWithFormat:@"%@", ([run payLumperFee] ? @"Yes" : @"No")];
    
    NSString* lumperFeeAmount = [BBHUtil isNull:[run lumperFee]] ? @"N/A" : [NSString stringWithFormat:@"%.2f", [[run lumperFee] doubleValue]];
    
    NSString* detentionFee = [NSString stringWithFormat:@"%@", [run payDetentionFee] ? @"Yes" : @"No"];
    
    NSString* detentionFeeAmount = [BBHUtil isNull:[run detentionFee]] ? @"N/A" : [NSString stringWithFormat:@"%.2f", [[run detentionFee] doubleValue]];
    
    NSString* fuelAdvance = [NSString stringWithFormat:@"%@", [run offerFuelAdvance] ? @"Yes" : @"No"];
    
    NSString* fueldAdvanceAmount = [BBHUtil isNull:[run fuelAdvanceAmount]] ? @"N/A" : [NSString stringWithFormat:@"%.2f", [[run fuelAdvanceAmount] doubleValue]];
    
    NSString* tonu = [NSString stringWithFormat:@"%@", [run tonuForOO] ? @"Yes" : @"No"];
    
    NSString* tonuPenaltyAmount = [BBHUtil isNull:[run tonuPenaltyAmount]] ? @"N/A" : [NSString stringWithFormat:@"%.2f", [[run tonuPenaltyAmount] doubleValue]];
    
    NSString* driverAssist = [NSString stringWithFormat:@"%@", [run driverAssist] ? @"Yes" : @"No"];
    
    NSString* dockAtFacility = [NSString stringWithFormat:@"%@", [run facilityWithDock] ? @"Yes" : @"No"];
    
    NSString* scaleTickets = [NSString stringWithFormat:@"%@", [run ooNeedScaleTickets] ? @"Yes" : @"No"];
    
    NSString* billOfLading = [NSString stringWithFormat:@"%@", [run needBillOfLoading] ? @"Yes" : @"No"];
    
    NSString* sealOnTrailer = [NSString stringWithFormat:@"%@", [run sealOnTrailer] ? @"Yes" : @"No"];
    
    [[self totalWeightLabel] setText:totalFreightWeight];
    [[self deliveryLabel] setText:delivery];
    [[self freightLoadingLabel] setText:freightLoading];
    [[self freightDescriptionLabel] setText:freightDesc];
    [[self lumperFeeLabel] setText:lumperFee];
    [[self lumperFeeAmountLabel] setText:lumperFeeAmount];
    [[self detentionFeeLabel] setText:detentionFee];
    [[self detentionFeeAmountLabel] setText:detentionFeeAmount];
    [[self fuelAdvanceLabel] setText:fuelAdvance];
    [[self fuelAdvanceAmountLabel] setText:fueldAdvanceAmount];
    [[self tonuLabel] setText:tonu];
    [[self tonuPenaltyAmountLabel] setText:tonuPenaltyAmount];
    [[self driverAssistanceLabel] setText:driverAssist];
    [[self dockFacilityLabel] setText:dockAtFacility];
    [[self scaleTicketsLabel] setText:scaleTickets];
    [[self billOfLadingLabel] setText:billOfLading];
    [[self sealOnTrailerLabel] setText:sealOnTrailer];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Freight" image:nil tag:20];
        [self setTabBarItem:tabBarItem];
    }
    
    return self;
}

-(void)viewDidLoad {
    
    [self toggleWait:YES];
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[[[[self runEntity] links] objectForKey:@"self"] href] absolute:YES params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if (response == RESTResponseSuccess) {
            
            NSLog(@"%@", data);
            [self setRunEntity:[[self runEntity] initWithDict:data]];
            
            [self makeUI];
            [self toggleWait:NO];
        }
    }];
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