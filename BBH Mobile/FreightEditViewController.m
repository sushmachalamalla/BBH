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
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setLumperFeeAmountLabel: [BBHUtil makeLabelWithText: @"Lumper Fee $" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setLumperFeeAmountTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
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
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setFuelAdvanceLabel: [BBHUtil makeLabelWithText: @"Fuel Advance Provided" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setFuelAdvanceSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self fuelAdvanceLabel]];
    [contentView addSubview:[self fuelAdvanceSwitch]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setTonuLabel: [BBHUtil makeLabelWithText: @"TONU" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setTonuSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self tonuLabel]];
    [contentView addSubview:[self tonuSwitch]];
    
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