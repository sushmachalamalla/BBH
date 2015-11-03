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

-(void) makeUI {
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [[self view] frame].size.width, 4000.0)];
    
    CGPoint orig = CGPointMake(8.0, 8.0);
    
    CGFloat labelWidth = 266.0;
    CGFloat labelHeight = 21.0;
    
    CGFloat tfWidth = 584.0;
    CGFloat tfHeight = 30.0;
    
    CGFloat pickerWidth = 300.0;
    CGFloat pickerHeight = 100.0;
    
    CGRect rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setTotalWeightLabel: [BBHUtil makeLabelWithText: @"Total Freight Weight" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setTotalWeightTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self totalWeightLabel]];
    [contentView addSubview:[self totalWeightTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDeliveryLabel: [BBHUtil makeLabelWithText:@"Delivery" frame:rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, pickerWidth, pickerHeight);
    [self setDeliveryPicker: [[UIPickerView alloc] initWithFrame:rect]];
    
    [[self deliveryPicker] setDelegate:[self deliveryDelegate]];
    [[self deliveryPicker] setDataSource:[self deliveryDelegate]];
    
    [contentView addSubview:[self deliveryLabel]];
    [contentView addSubview:[self deliveryPicker]];
    
    orig.y += [[self deliveryPicker] frame].size.height + 8.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setFreightLoadingLabel:[BBHUtil makeLabelWithText:@"Freight Loading" frame:rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, pickerWidth, pickerHeight);
    [self setFreightLoadingPicker: [[UIPickerView alloc] initWithFrame:rect]];
    
    [[self freightLoadingPicker] setDelegate:[self freightLoadingDelegate]];
    [[self freightLoadingPicker] setDataSource:[self freightLoadingDelegate]];
    
    [contentView addSubview:[self freightLoadingLabel]];
    [contentView addSubview:[self freightLoadingPicker]];
    
    orig.y += [[self freightLoadingPicker] frame].size.height + 8.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setFreightDescriptionLabel: [BBHUtil makeLabelWithText: @"Freight Description" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setFreightDescriptionTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self freightDescriptionLabel]];
    [contentView addSubview:[self freightDescriptionTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setLumperFeeLabel:[BBHUtil makeLabelWithText: @"Lumper Fee" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setLumperFeeSwitch:[[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self lumperFeeLabel]];
    [contentView addSubview:[self lumperFeeSwitch]];
    
    [[self lumperFeeSwitch] addTarget:self action:@selector(lumperSwitchChanged) forControlEvents:UIControlEventValueChanged];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setLumperFeeAmountLabel: [BBHUtil makeLabelWithText: @"Lumper Fee $" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setLumperFeeAmountTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    [[self lumperFeeAmountTF] setEnabled:[[self runEntity] payLumperFee]];
    
    [contentView addSubview:[self lumperFeeAmountLabel]];
    [contentView addSubview:[self lumperFeeAmountTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDetentionFeeLabel: [BBHUtil makeLabelWithText: @"Detention Fee" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setDetentionFeeSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self detentionFeeLabel]];
    [contentView addSubview:[self detentionFeeSwitch]];
    
    [[self detentionFeeSwitch] addTarget:self action:@selector(detentionSwitchChanged) forControlEvents:UIControlEventValueChanged];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDetentionFeeAmountLabel: [BBHUtil makeLabelWithText: @"Detention Fee $" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setDetentionFeeAmountTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self detentionFeeAmountLabel]];
    [contentView addSubview:[self detentionFeeAmountTF]];
    [[self detentionFeeAmountTF] setEnabled:[[self runEntity] payDetentionFee]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setFuelAdvanceLabel: [BBHUtil makeLabelWithText: @"Fuel Advance Provided" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setFuelAdvanceSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self fuelAdvanceLabel]];
    [contentView addSubview:[self fuelAdvanceSwitch]];
    
    [[self fuelAdvanceSwitch] addTarget:self action:@selector(fuelSwitchChanged) forControlEvents:UIControlEventValueChanged];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setFuelAdvanceAmountLabel: [BBHUtil makeLabelWithText: @"Fuel Advance $" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setFuelAdvanceAmountTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    [[self fuelAdvanceAmountTF] setEnabled:[[self runEntity] offerFuelAdvance]];
    
    [contentView addSubview:[self fuelAdvanceAmountLabel]];
    [contentView addSubview:[self fuelAdvanceAmountTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setTonuLabel: [BBHUtil makeLabelWithText: @"TONU" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setTonuSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self tonuLabel]];
    [contentView addSubview:[self tonuSwitch]];
    
    [[self tonuSwitch] addTarget:self action:@selector(tonuSwitchChanged) forControlEvents:UIControlEventValueChanged];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setTonuPenaltyAmountLabel: [BBHUtil makeLabelWithText: @"TONU Penalty $" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setTonuPenaltyAmountTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    [[self tonuPenaltyAmountTF] setEnabled:[[self runEntity] tonuForOO]];
    
    [contentView addSubview:[self tonuPenaltyAmountLabel]];
    [contentView addSubview:[self tonuPenaltyAmountTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDriverAssistanceLabel: [BBHUtil makeLabelWithText: @"Driver Assistance Provided" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setDriverAssistanceSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self driverAssistanceLabel]];
    [contentView addSubview:[self driverAssistanceSwitch]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDockFacilityLabel: [BBHUtil makeLabelWithText: @"Dock At Facility" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setDockFacilitySwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self dockFacilityLabel]];
    [contentView addSubview:[self dockFacilitySwitch]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setScaleTicketsLabel: [BBHUtil makeLabelWithText: @"Scale Tickets Needed" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setScaleTicketsSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self scaleTicketsLabel]];
    [contentView addSubview:[self scaleTicketsSwitch]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setBillOfLadingLabel: [BBHUtil makeLabelWithText: @"Bill of Lading Provided" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setBillOfLadingSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self billOfLadingLabel]];
    [contentView addSubview:[self billOfLadingSwitch]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setSealOnTrailerLabel: [BBHUtil makeLabelWithText: @"Seal on Trailer" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setSealOnTrailerSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self sealOnTrailerLabel]];
    [contentView addSubview:[self sealOnTrailerSwitch]];
    
    [[self scrollView] setContentSize:CGSizeMake([[self view] frame].size.width, orig.y+150.0)];
    [[self scrollView] addSubview:contentView];
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
    
    [BBHUtil showAlert:self handler:handler];
}

-(void)saveInfo {
    
    NSLog(@"Saving Freight Info");
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