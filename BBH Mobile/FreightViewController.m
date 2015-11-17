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

-(void) updateViewConstraints {
    
    [[self scrollView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo([self view].mas_left).with.offset(0.0);
        make.top.equalTo([self view].mas_top).with.offset(0.0);
        make.right.equalTo([self view].mas_right).with.offset(0.0);
        make.bottom.equalTo([self view].mas_bottom).with.offset(0.0);
    }];
    
    UIView* contentView = (UIView*)[[[self scrollView] subviews] objectAtIndex:0];
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo([self scrollView].mas_left);
        make.top.equalTo([self scrollView].mas_top);
        make.right.equalTo([self scrollView].mas_right);
        make.bottom.equalTo([self scrollView].mas_bottom);
    }];
    
    NSArray* array = [[NSArray alloc] initWithObjects:[self totalWeightKeyLabel], [self deliveryKeyLabel], [self freightLoadingKeyLabel], [self freightDescriptionKeyLabel], [self lumperFeeKeyLabel], [self lumperFeeAmountKeyLabel], [self detentionFeeKeyLabel], [self detentionFeeAmountKeyLabel], [self fuelAdvanceKeyLabel], [self fuelAdvanceAmountKeyLabel], [self tonuKeyLabel], [self tonuPenaltyAmountKeyLabel], [self driverAssistanceKeyLabel], [self dockFacilityKeyLabel], [self scaleTicketsKeyLabel], [self billOfLadingKeyLabel], [self billOfLadingKeyLabel], [self sealOnTrailerKeyLabel], nil];
    
    CGPoint offset = CGPointMake(5.0, 5.0);
    CGSize box = CGSizeMake(0.0, 0.0);
    
    box = [BBHUtil makeStack:array superview:contentView offset:offset];
    
    array = [[NSArray alloc] initWithObjects:[self totalWeightLabel], [self deliveryLabel], [self freightLoadingLabel], [self freightDescriptionLabel], [self lumperFeeLabel], [self lumperFeeAmountLabel], [self detentionFeeLabel], [self detentionFeeAmountLabel], [self fuelAdvanceLabel], [self fuelAdvanceAmountLabel], [self tonuLabel], [self tonuPenaltyAmountLabel], [self driverAssistanceLabel], [self dockFacilityLabel], [self scaleTicketsLabel], [self billOfLadingLabel], [self billOfLadingLabel], [self sealOnTrailerLabel], nil];
    
    offset.x = box.width + 5.0;
    box = [BBHUtil makeStack:array superview:contentView offset:offset];
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo([self sealOnTrailerKeyLabel].mas_bottom).with.offset(10.0);
    }];
    
    [super updateViewConstraints];
}

-(void) makeUI {
    
    UIView* contentView = [[UIView alloc] init];
    
    [self setTotalWeightKeyLabel:[BBHUtil makeLabelWithText:@"Total Freight Weight:"]];
    [self setDeliveryKeyLabel:[BBHUtil makeLabelWithText:@"Delivery:"]];
    [self setFreightLoadingKeyLabel:[BBHUtil makeLabelWithText:@"Freight Loading:"]];
    [self setFreightDescriptionKeyLabel:[BBHUtil makeLabelWithText:@"Freight Description:"]];
    [self setLumperFeeKeyLabel:[BBHUtil makeLabelWithText:@"Lumper Fee:"]];
    [self setLumperFeeAmountKeyLabel:[BBHUtil makeLabelWithText:@"Lumper Fee $:"]];
    [self setDetentionFeeKeyLabel:[BBHUtil makeLabelWithText:@"Detention Fee:"]];
    [self setDetentionFeeAmountKeyLabel:[BBHUtil makeLabelWithText:@"Detention Fee $:"]];
    [self setFuelAdvanceKeyLabel:[BBHUtil makeLabelWithText:@"Fuel Advance Provided:"]];
    [self setFuelAdvanceAmountKeyLabel:[BBHUtil makeLabelWithText:@"Fuel Advance $:"]];
    [self setTonuKeyLabel:[BBHUtil makeLabelWithText:@"TONU:"]];
    [self setTonuPenaltyAmountKeyLabel:[BBHUtil makeLabelWithText:@"TONU Penalty $:"]];
    [self setDriverAssistanceKeyLabel:[BBHUtil makeLabelWithText:@"Driver Assistance Provided:"]];
    [self setDockFacilityKeyLabel:[BBHUtil makeLabelWithText:@"Dock at Facility:"]];
    [self setScaleTicketsKeyLabel:[BBHUtil makeLabelWithText:@"Scale Tickets Needed:"]];
    [self setBillOfLadingKeyLabel:[BBHUtil makeLabelWithText:@"Bill of Lading Provided:"]];
    [self setSealOnTrailerKeyLabel:[BBHUtil makeLabelWithText:@"Seal on Trailer:"]];
    
    [self setTotalWeightLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setDeliveryLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setFreightLoadingLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setFreightDescriptionLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setLumperFeeLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setLumperFeeAmountLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setDetentionFeeLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setDetentionFeeAmountLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setFuelAdvanceLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setFuelAdvanceAmountLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setTonuLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setTonuPenaltyAmountLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setDriverAssistanceLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setDockFacilityLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setScaleTicketsLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setBillOfLadingLabel:[BBHUtil makeLabelWithText:@"-"]];
    [self setSealOnTrailerLabel:[BBHUtil makeLabelWithText:@"-"]];
    
    [contentView addSubview:[self totalWeightKeyLabel]];
    [contentView addSubview:[self totalWeightLabel]];
    [contentView addSubview:[self deliveryKeyLabel]];;
    [contentView addSubview:[self deliveryLabel]];
    [contentView addSubview:[self freightLoadingKeyLabel]];
    [contentView addSubview:[self freightLoadingLabel]];
    [contentView addSubview:[self freightDescriptionKeyLabel]];
    [contentView addSubview:[self freightDescriptionLabel]];
    [contentView addSubview:[self lumperFeeKeyLabel]];
    [contentView addSubview:[self lumperFeeLabel]];
    [contentView addSubview:[self lumperFeeAmountKeyLabel]];;
    [contentView addSubview:[self lumperFeeAmountLabel]];
    [contentView addSubview:[self detentionFeeKeyLabel]];
    [contentView addSubview:[self detentionFeeLabel]];
    [contentView addSubview:[self detentionFeeAmountKeyLabel]];;
    [contentView addSubview:[self detentionFeeAmountLabel]];
    [contentView addSubview:[self fuelAdvanceKeyLabel]];
    [contentView addSubview:[self fuelAdvanceLabel]];
    [contentView addSubview:[self fuelAdvanceAmountKeyLabel]];
    [contentView addSubview:[self fuelAdvanceAmountLabel]];
    [contentView addSubview:[self tonuKeyLabel]];
    [contentView addSubview:[self tonuLabel]];
    [contentView addSubview:[self tonuPenaltyAmountKeyLabel]];
    [contentView addSubview:[self tonuPenaltyAmountLabel]];
    [contentView addSubview:[self driverAssistanceKeyLabel]];
    [contentView addSubview:[self driverAssistanceLabel]];
    [contentView addSubview:[self dockFacilityKeyLabel]];
    [contentView addSubview:[self dockFacilityLabel]];
    [contentView addSubview:[self scaleTicketsKeyLabel]];
    [contentView addSubview:[self scaleTicketsLabel]];
    [contentView addSubview:[self billOfLadingKeyLabel]];
    [contentView addSubview:[self billOfLadingLabel]];
    [contentView addSubview:[self sealOnTrailerKeyLabel]];
    [contentView addSubview:[self sealOnTrailerLabel]];
    
    [self setScrollView:[[UIScrollView alloc] init]];
    [[self scrollView] setScrollEnabled:YES];
    [[self scrollView] setPagingEnabled:NO];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [[self scrollView] addSubview:contentView];
    [[self view] addSubview:[self scrollView]];
}

-(void)populate {
    
    Run* run = [self runEntity];
    
    NSString* totalFreightWeight = [BBHUtil isNull:[run totalFreightWeight]] ? @"N/A" : [NSString stringWithFormat:@"%.2f", [[run totalFreightWeight] doubleValue]];
    
    NSString* delivery = [BBHUtil isNull:[run deliveryScheduleType]] ? @"N/A" : [[run deliveryScheduleType] deliveryScheduleTypeName];
    
    NSString* freightLoading = [BBHUtil isNull:[run loadingType]] ? @"N/A" : [[run loadingType] loadingTypeName];
    
    NSString* freightDesc = ([BBHUtil isNull:[run freightDetails]] || [BBHUtil isEmpty:[run freightDetails]]) ? @"N/A" : [run freightDetails];
    
    NSLog(@">> Desc: %d", [freightDesc length]);
    
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
    
    [[self view] setNeedsUpdateConstraints];
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
    [self makeUI];
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[[[[self runEntity] links] objectForKey:@"self"] href] absolute:YES params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if (response == RESTResponseSuccess) {
            
            NSLog(@"%@", data);
            [self setRunEntity:[[self runEntity] initWithDict:data]];
            
            [self populate];
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