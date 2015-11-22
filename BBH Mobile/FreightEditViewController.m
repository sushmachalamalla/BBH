//
//  FreightEditViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/27/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FreightEditViewController.h"

@implementation FreightEditViewController

@synthesize mode;
@synthesize isClean;
@synthesize isUIDone;

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Freight" image:nil tag:10];
        [self setTabBarItem:tabBarItem];
    }
    
    return self;
}

-(void)viewDidLoad {
    
    [[self scrollView] setScrollEnabled:YES];
    [[self scrollView] setDelegate:self];
    
    [[self scrollView] flashScrollIndicators];
    
    [self setDeliveryDelegate:[[PickerDelegate alloc] init]];
    [self setFreightLoadingDelegate:[[PickerDelegate alloc] init]];
    
    [self makeUI];
    
    if([[self runEntity] runId] > 0) {
        
        [self populate];
    }
}

-(void) populate {
    
    RESTClient* client = [RESTClient instance];
    
    double totalWeight =  [[[self runEntity] totalFreightWeight] doubleValue];
    [[self totalWeightTF] setText:[NSString stringWithFormat:@"%.2f", totalWeight]];
    
    int deliveryTypeId = [[[self runEntity] deliveryScheduleType] deliveryScheduleTypeId];
    __block DeliveryScheduleType* selDeliveryType = nil;
    
    [client doGETWithURL:@"deliveryScheduleTypes" params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        //NSLog([NSString stringWithFormat:@"SUCCESS >> %@", data]);
        
        NSArray* types = [data valueForKey:@"DeliveryScheduleTypes"];
        
        [types enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            DeliveryScheduleType* deliveryType = [[DeliveryScheduleType alloc] initWithDict:obj];
            [[[self deliveryDelegate] content] addObject:deliveryType];
            
            if ([deliveryType deliveryScheduleTypeId] == deliveryTypeId) {
                selDeliveryType = deliveryType;
            }
        }];
        
        [[self deliveryPicker] reloadAllComponents];
        
        if(selDeliveryType) {
            
            [[self deliveryPicker] selectRow:[[[self deliveryDelegate] content] indexOfObject:selDeliveryType] inComponent:0 animated:YES];
        }
    }];
    
    int loadingTypeId = [[[self runEntity] loadingType] loadingTypeId];
    __block LoadingType* selLoadingType = nil;
    
    [client doGETWithURL:@"loadingTypes" params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        //NSLog([NSString stringWithFormat:@"SUCCESS >> %@", data]);
        
        NSArray* types = [data valueForKey:@"LoadingTypes"];
        
        [types enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            LoadingType* loadingType = [[LoadingType alloc] initWithDict:obj];
            [[[self freightLoadingDelegate] content] addObject:loadingType];
            
            if ([loadingType loadingTypeId] == loadingTypeId) {
                selLoadingType = loadingType;
            }
        }];
        
        [[self freightLoadingPicker] reloadAllComponents];
        
        if(selLoadingType) {
            
            [[self freightLoadingPicker] selectRow:[[[self freightLoadingDelegate] content] indexOfObject:selLoadingType] inComponent:0 animated:YES];
        }
    }];
    
    [[self freightDescriptionTF] setText:[[self runEntity] freightDetails]];
    [[self lumperFeeSwitch] setOn:[[self runEntity] payLumperFee]];
    
    if ([[self runEntity] payLumperFee]) {
        
        double lumperFeeAmount = [[[self runEntity] lumperFee] doubleValue];
        [[self lumperFeeAmountTF] setText:[NSString stringWithFormat:@"%.2f", lumperFeeAmount]];
    }
    
    [[self detentionFeeSwitch] setOn:[[self runEntity] payDetentionFee]];
    
    if ([[self runEntity] payDetentionFee]) {
        
        double detentionFeeAmount = [[[self runEntity] detentionFee] doubleValue];
        [[self detentionFeeAmountTF] setText:[NSString stringWithFormat:@"%.2f", detentionFeeAmount]];
    }
    
    [[self tonuSwitch] setOn:[[self runEntity] tonuForOO]];
    
    if ([[self runEntity] tonuForOO]) {
        
        double tonuPenaltyAmount = [[[self runEntity] tonuPenaltyAmount] doubleValue];
        [[self tonuPenaltyAmountTF] setText:[NSString stringWithFormat:@"%.2f", tonuPenaltyAmount]];
    }
    
    [[self fuelAdvanceSwitch] setOn:[[self runEntity] offerFuelAdvance]];
    if ([[self runEntity] offerFuelAdvance]) {
        
        double fueldAdvanceAmount = [[[self runEntity] fuelAdvanceAmount] doubleValue];
        [[self fuelAdvanceAmountTF] setText:[NSString stringWithFormat:@"%.2f", fueldAdvanceAmount]];
    }
    
    [[self driverAssistanceSwitch] setOn:[[self runEntity] driverAssist]];
    [[self dockFacilitySwitch] setOn:[[self runEntity] facilityWithDock]];
    [[self scaleTicketsSwitch] setOn:[[self runEntity] ooNeedScaleTickets]];
    [[self billOfLadingSwitch] setOn:[[self runEntity] needBillOfLoading]];
    [[self sealOnTrailerSwitch] setOn:[[self runEntity] sealOnTrailer]];    
}

-(void)updateViewConstraints {
    
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
        make.width.equalTo([self view].mas_width).with.offset(-10.0);
    }];
    
    NSArray* array = [[NSArray alloc] initWithObjects:[self totalWeightLabel], [self totalWeightTF], [self deliveryLabel], [self deliveryPicker], [self freightLoadingLabel], [self freightLoadingPicker], [self freightDescriptionLabel], [self freightDescriptionTF], [self lumperFeeLabel], [self lumperFeeSwitch], [self lumperFeeAmountLabel], [self lumperFeeAmountTF], [self detentionFeeLabel], [self detentionFeeSwitch], [self detentionFeeAmountLabel], [self detentionFeeAmountTF], [self fuelAdvanceLabel], [self fuelAdvanceSwitch], [self fuelAdvanceAmountLabel], [self fuelAdvanceAmountTF], [self tonuLabel], [self tonuSwitch], [self tonuPenaltyAmountLabel], [self tonuPenaltyAmountTF], [self driverAssistanceLabel], [self driverAssistanceSwitch], [self dockFacilityLabel], [self dockFacilitySwitch], [self scaleTicketsLabel], [self scaleTicketsSwitch], [self billOfLadingLabel], [self billOfLadingSwitch], [self sealOnTrailerLabel], [self sealOnTrailerSwitch], nil];
    
    CGPoint offset = CGPointMake(5.0, 5.0);
    [BBHUtil makeStackEdit:array superview:contentView offset:offset];
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        //make.right.equalTo([self runTitleLabel]).with.offset(10.0);
        make.bottom.equalTo([self sealOnTrailerSwitch].mas_bottom).with.offset(10.0);
    }];
    
    [super updateViewConstraints];
}

-(void) makeUI {
    
    UIView* contentView = [[UIView alloc] init];
    
    [self setTotalWeightLabel: [BBHUtil makeLabelWithText: @"Total Freight Weight"]];
    [self setTotalWeightTF: [BBHUtil makeTextFieldWithText:@"Total Weight"]];
    
    [contentView addSubview:[self totalWeightLabel]];
    [contentView addSubview:[self totalWeightTF]];
    
    [self setDeliveryLabel: [BBHUtil makeLabelWithText:@"Delivery"]];
    [self setDeliveryPicker: [[UIPickerView alloc] init]];
    
    [[self deliveryPicker] setDelegate:[self deliveryDelegate]];
    [[self deliveryPicker] setDataSource:[self deliveryDelegate]];
    
    [contentView addSubview:[self deliveryLabel]];
    [contentView addSubview:[self deliveryPicker]];
    
    [self setFreightLoadingLabel:[BBHUtil makeLabelWithText:@"Freight Loading"]];
    [self setFreightLoadingPicker: [[UIPickerView alloc] init]];
    
    [[self freightLoadingPicker] setDelegate:[self freightLoadingDelegate]];
    [[self freightLoadingPicker] setDataSource:[self freightLoadingDelegate]];
    
    [contentView addSubview:[self freightLoadingLabel]];
    [contentView addSubview:[self freightLoadingPicker]];
    
    [self setFreightDescriptionLabel: [BBHUtil makeLabelWithText: @"Freight Description"]];
    [self setFreightDescriptionTF: [BBHUtil makeTextFieldWithText:@"Freight Description"]];
    
    [contentView addSubview:[self freightDescriptionLabel]];
    [contentView addSubview:[self freightDescriptionTF]];
    
    [self setLumperFeeLabel:[BBHUtil makeLabelWithText: @"Lumper Fee"]];
    [self setLumperFeeSwitch:[[UISwitch alloc] init]];
    
    [contentView addSubview:[self lumperFeeLabel]];
    [contentView addSubview:[self lumperFeeSwitch]];
    
    [[self lumperFeeSwitch] addTarget:self action:@selector(lumperSwitchChanged) forControlEvents:UIControlEventValueChanged];
    
    [self setLumperFeeAmountLabel: [BBHUtil makeLabelWithText: @"Lumper Fee $"]];
    
    [self setLumperFeeAmountTF: [BBHUtil makeTextFieldWithText:@"Lumper Fee Amount"]];
    [[self lumperFeeAmountTF] setEnabled:[[self runEntity] payLumperFee]];
    
    [contentView addSubview:[self lumperFeeAmountLabel]];
    [contentView addSubview:[self lumperFeeAmountTF]];
    
    [self setDetentionFeeLabel: [BBHUtil makeLabelWithText: @"Detention Fee"]];
    [self setDetentionFeeSwitch: [[UISwitch alloc] init]];
    
    [contentView addSubview:[self detentionFeeLabel]];
    [contentView addSubview:[self detentionFeeSwitch]];
    
    [[self detentionFeeSwitch] addTarget:self action:@selector(detentionSwitchChanged) forControlEvents:UIControlEventValueChanged];
    
    [self setDetentionFeeAmountLabel: [BBHUtil makeLabelWithText: @"Detention Fee $"]];
    [self setDetentionFeeAmountTF: [BBHUtil makeTextFieldWithText:@"Detention Fee Amount"]];
    
    [contentView addSubview:[self detentionFeeAmountLabel]];
    [contentView addSubview:[self detentionFeeAmountTF]];
    
    [[self detentionFeeAmountTF] setEnabled:[[self runEntity] payDetentionFee]];
    
    [self setFuelAdvanceLabel: [BBHUtil makeLabelWithText: @"Fuel Advance Provided"]];
    [self setFuelAdvanceSwitch: [[UISwitch alloc] init]];
    
    [contentView addSubview:[self fuelAdvanceLabel]];
    [contentView addSubview:[self fuelAdvanceSwitch]];
    
    [[self fuelAdvanceSwitch] addTarget:self action:@selector(fuelSwitchChanged) forControlEvents:UIControlEventValueChanged];
    
    [self setFuelAdvanceAmountLabel: [BBHUtil makeLabelWithText: @"Fuel Advance $"]];
    [self setFuelAdvanceAmountTF: [BBHUtil makeTextFieldWithText:@"Fuel Advance Amount"]];
    
    [[self fuelAdvanceAmountTF] setEnabled:[[self runEntity] offerFuelAdvance]];
    
    [contentView addSubview:[self fuelAdvanceAmountLabel]];
    [contentView addSubview:[self fuelAdvanceAmountTF]];
    
    [self setTonuLabel: [BBHUtil makeLabelWithText: @"TONU"]];
    [self setTonuSwitch: [[UISwitch alloc] init]];
    
    [contentView addSubview:[self tonuLabel]];
    [contentView addSubview:[self tonuSwitch]];
    
    [[self tonuSwitch] addTarget:self action:@selector(tonuSwitchChanged) forControlEvents:UIControlEventValueChanged];
    
    [self setTonuPenaltyAmountLabel: [BBHUtil makeLabelWithText: @"TONU Penalty $"]];
    
    [self setTonuPenaltyAmountTF: [BBHUtil makeTextFieldWithText:@"TONU Penalty Amount"]];
    [[self tonuPenaltyAmountTF] setEnabled:[[self runEntity] tonuForOO]];
    
    [contentView addSubview:[self tonuPenaltyAmountLabel]];
    [contentView addSubview:[self tonuPenaltyAmountTF]];
    
    [self setDriverAssistanceLabel: [BBHUtil makeLabelWithText: @"Driver Assistance Provided"]];
    [self setDriverAssistanceSwitch: [[UISwitch alloc] init]];
    
    [contentView addSubview:[self driverAssistanceLabel]];
    [contentView addSubview:[self driverAssistanceSwitch]];
    
    [self setDockFacilityLabel: [BBHUtil makeLabelWithText: @"Dock At Facility"]];
    [self setDockFacilitySwitch: [[UISwitch alloc] init]];
    
    [contentView addSubview:[self dockFacilityLabel]];
    [contentView addSubview:[self dockFacilitySwitch]];
    
    [self setScaleTicketsLabel: [BBHUtil makeLabelWithText: @"Scale Tickets Needed"]];
    [self setScaleTicketsSwitch: [[UISwitch alloc] init]];
    
    [contentView addSubview:[self scaleTicketsLabel]];
    [contentView addSubview:[self scaleTicketsSwitch]];
    
    [self setBillOfLadingLabel: [BBHUtil makeLabelWithText: @"Bill of Lading Provided"]];
    [self setBillOfLadingSwitch: [[UISwitch alloc] init]];
    
    [contentView addSubview:[self billOfLadingLabel]];
    [contentView addSubview:[self billOfLadingSwitch]];
    
    [self setSealOnTrailerLabel: [BBHUtil makeLabelWithText: @"Seal on Trailer"]];
    [self setSealOnTrailerSwitch: [[UISwitch alloc] init]];
    
    [contentView addSubview:[self sealOnTrailerLabel]];
    [contentView addSubview:[self sealOnTrailerSwitch]];
    
    [self setScrollView:[[UIScrollView alloc] init]];
    [[self scrollView] setScrollEnabled:YES];
    [[self scrollView] setPagingEnabled:NO];
    [[self scrollView] setDelegate:self];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [[self scrollView] addSubview:contentView];
    [[self view] addSubview:[self scrollView]];
}

-(void) detentionSwitchChanged {
    
    if ([[self detentionFeeSwitch] isOn]) {
        
        [[self detentionFeeAmountTF] setEnabled:YES];
        [[self detentionFeeAmountTF] setText:[NSString stringWithFormat:@"%.2f",[[[self runEntity] detentionFee] doubleValue]]];
        
    } else {
        
        [[self detentionFeeAmountTF] setEnabled:NO];
        [[self detentionFeeAmountTF] setText:@""];
    }
}

-(void) lumperSwitchChanged {
    
    if ([[self lumperFeeSwitch] isOn]) {
        
        [[self lumperFeeAmountTF] setEnabled:YES];
        [[self lumperFeeAmountTF] setText:[NSString stringWithFormat:@"%.2f",[[[self runEntity] lumperFee] doubleValue]]];
        
    } else {
        
        [[self lumperFeeAmountTF] setEnabled:NO];
        [[self lumperFeeAmountTF] setText:@""];
    }
}

-(void) fuelSwitchChanged {
    
    if ([[self fuelAdvanceSwitch] isOn]) {
        
        [[self fuelAdvanceAmountTF] setEnabled:YES];
        [[self fuelAdvanceAmountTF] setText:[NSString stringWithFormat:@"%.2f",[[[self runEntity] fuelAdvanceAmount] doubleValue]]];
        
    } else {
        
        [[self fuelAdvanceAmountTF] setEnabled:NO];
        [[self fuelAdvanceAmountTF] setText:@""];
    }
}

-(void) tonuSwitchChanged {
    
    if ([[self tonuSwitch] isOn]) {
        
        [[self tonuPenaltyAmountTF] setEnabled:YES];
        [[self tonuPenaltyAmountTF] setText:[NSString stringWithFormat:@"%.2f",[[[self runEntity] tonuPenaltyAmount] doubleValue]]];
        
    } else {
        
        [[self tonuPenaltyAmountTF] setEnabled:NO];
        [[self tonuPenaltyAmountTF] setText:@""];
    }
}

-(void) confirmSave: (void (^)(ConfirmResponse)) handler {
    
    [BBHUtil showConfirmSave:self handler:handler];
}

-(void)saveInfo {
    
    NSLog(@"Saving Freight Info");
    Run* run = [[Run alloc] initWithDict:[[self runEntity] exportToDict]];
    
    NSString* sTotalWeight = [[self totalWeightTF] text];
    NSNumber* totalWeight = [BBHUtil readDecimal:sTotalWeight];
    
    DeliveryScheduleType* deliveryType = [[[self deliveryDelegate] content] objectAtIndex:[[self deliveryPicker] selectedRowInComponent:0]];
    
    LoadingType* loadingType = [[[self freightLoadingDelegate] content] objectAtIndex:[[self freightLoadingPicker] selectedRowInComponent:0]];
    
    NSString* freightDesc = [[self freightDescriptionTF] text];
    
    BOOL lumperFee = [[self lumperFeeSwitch] isOn];
    
    NSString* sLumperFeeAmount = [[self lumperFeeAmountTF] text];
    NSNumber* lumperFeeAmount = [BBHUtil readDecimal:sLumperFeeAmount];
    
    BOOL detentionFee = [[self detentionFeeSwitch] isOn];
    
    NSString* sDetentionFeeAmount = [[self detentionFeeAmountTF] text];
    NSNumber* detentionFeeAmount = [BBHUtil readDecimal:sDetentionFeeAmount];
    
    BOOL fuelAdvance = [[self fuelAdvanceSwitch] isOn];
    
    NSString* sFuelAdvanceAmount = [[self fuelAdvanceAmountTF] text];
    NSNumber* fuelAdvanceAmount = [BBHUtil readDecimal:sFuelAdvanceAmount];
    
    BOOL tonu = [[self tonuSwitch] isOn];
    
    NSString* sTonuPenaltyAmount = [[self tonuPenaltyAmountTF] text];
    NSNumber* tonuPenaltyAmount = [BBHUtil readDecimal:sTonuPenaltyAmount];
    
    BOOL driverAssistance = [[self driverAssistanceSwitch] isOn];
    BOOL dockFacility = [[self dockFacilitySwitch] isOn];
    BOOL scaleTickets = [[self scaleTicketsSwitch] isOn];
    BOOL billOfLading = [[self billOfLadingSwitch] isOn];
    BOOL sealOnTrailer = [[self sealOnTrailerSwitch] isOn];
    
    [run setTotalFreightWeight:totalWeight];
    [run setDeliveryScheduleType:deliveryType];
    [run setLoadingType:loadingType];
    [run setFreightDetails:([BBHUtil isEmpty: freightDesc] ? nil : freightDesc)];
    [run setPayLumperFee:lumperFee];
    [run setLumperFee:lumperFeeAmount];
    [run setPayDetentionFee:detentionFee];
    [run setDetentionFee:detentionFeeAmount];
    [run setOfferFuelAdvance:fuelAdvance];
    [run setFuelAdvanceAmount:fuelAdvanceAmount];
    [run setTonuForOO:tonu];
    [run setTonuPenaltyAmount:tonuPenaltyAmount];
    [run setDriverAssist:driverAssistance];
    [run setFacilityWithDock:dockFacility];
    [run setOoNeedScaleTickets:scaleTickets];
    [run setNeedBillOfLoading:billOfLading];
    [run setSealOnTrailer:sealOnTrailer];
    
    NSError* error = nil;
    NSDictionary* dict = [run exportToDict];
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    
    if(data && !error) {
        
        RESTClient* client = [RESTClient instance];
        Link* link = [[run links] valueForKey:@"updateRun"];
        
        [client doPUTWithURL:[link href] absolute:YES data:data complete:^(RESTResponse response, NSDictionary* dict) {
            
            NSLog(@">>> PUT Response: %ld %@", (long)response, dict);
        }];
        
    } else {
        
        NSLog(@"Error serealizing to JSON");
    }
}

-(void)success:(NSDictionary *)data {
    //
}

-(void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    //
}

-(void)progress:(NSNumber *)percent {
    //
}

@end