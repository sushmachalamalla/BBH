//
//  GeneralInfoEditViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/14/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralInfoEditViewController.h"

@implementation GeneralInfoEditViewController

@synthesize mode;

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"General" image:nil tag:10];
        [self setTabBarItem:tabBarItem];
    }
    
    return self;
}

-(void)viewDidLoad {
    
    [[self scrollView] setScrollEnabled:YES];
    [[self scrollView] setDelegate:self];
    
    [[self scrollView] flashScrollIndicators];
    
    [self setDriverTypeDelegate:[[PickerDelegate alloc] init]];
    [self setFrequencyDelegate:[[PickerDelegate alloc] init]];
    [self setDriverClassDelegate:[[PickerDelegate alloc] init]];
    [self setPickupLocationTypeDelegate:[[PickerDelegate alloc] init]];
    [self setDropLocationTypeDelegate:[[PickerDelegate alloc] init]];
    
    [self makeUI];
    
    if([[self runEntity] runId] > 0) {
        
        [self populate];
    }
}

-(void) populate {
    
    [[self runtTitleTF] setText:[[self runEntity] runTitle]];
    
    RESTClient* client = [RESTClient instance];
    
    int driverTypeId = [[[self runEntity] driverType] driverTypeId];
    __block DriverType* selDriverType = nil;
    
    [client doGETWithURL:@"driverTypes" data:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        //NSLog([NSString stringWithFormat:@"SUCCESS >> %@", data]);
        
        NSArray* types = [data valueForKey:@"DriverTypes"];
        
        [types enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            DriverType* driverType = [[DriverType alloc] initWithDict:obj];
            [[[self driverTypeDelegate] content] addObject:driverType];
            
            if ([driverType driverTypeId] == driverTypeId) {
                selDriverType = driverType;
            }
        }];
        
        [[self driverTypePicker] reloadAllComponents];
        [[self driverTypePicker] selectRow:[[[self driverTypeDelegate] content] indexOfObject:selDriverType] inComponent:0 animated:YES];
    }];
    
    int frequencyId = [[[self runEntity] runFrequency] runFrequencyId];
    __block RunFrequency* selFrequency = nil;
    
    [client doGETWithURL:@"runFrequencies" data:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        //NSLog([NSString stringWithFormat:@"SUCCESS >> %@", data]);
        
        NSArray* types = [data valueForKey:@"RunFrequencies"];
        
        [types enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RunFrequency* runFrequency = [[RunFrequency alloc] initWithDict:obj];
            [[[self frequencyDelegate] content] addObject:runFrequency];
            
            if ([runFrequency runFrequencyId] == frequencyId) {
                selFrequency = runFrequency;
            }
        }];
        
        [[self freqPicker] reloadAllComponents];
        if(selFrequency) {
            
            [[self freqPicker] selectRow:[[[self frequencyDelegate] content] indexOfObject:selFrequency] inComponent:0 animated:YES];
        }
    }];
    
    int driverClassId = [[[self runEntity] driverClass] driverClassId];
    __block DriverClass* selDriverClass = nil;
    
    [client doGETWithURL:@"driverClasses" data:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        //NSLog([NSString stringWithFormat:@"SUCCESS >> %@", data]);
        
        NSArray* classes = [data valueForKey:@"DriverClasses"];
        
        [classes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            DriverClass* driverClass = [[DriverClass alloc] initWithDict:obj];
            [[[self driverClassDelegate] content] addObject:driverClass];
            
            if ([driverClass driverClassId] == driverClassId) {
                selDriverClass = driverClass;
            }
        }];
        
        [[self driverClassPicker] reloadAllComponents];
        if(selDriverClass) {
            [[self driverClassPicker] selectRow:[[[self driverClassDelegate] content] indexOfObject:selDriverClass] inComponent:0 animated:YES];
        }
    }];
    
    int pickupLocationTypeId = [[[self runEntity] pickupLocationType] locationTypeId];
    __block LocationType* selPickupLocationType = nil;
    
    int dropLocationTypeId = [[[self runEntity] dropOffLocationType] locationTypeId];
    __block LocationType* selDropLocationType = nil;
    
    [client doGETWithURL:@"locationTypes" data:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        //NSLog([NSString stringWithFormat:@"SUCCESS >> %@", data]);
        
        NSArray* classes = [data valueForKey:@"LocationTypes"];
        
        [classes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            LocationType* locationType = [[LocationType alloc] initWithDict:obj];
            [[[self pickupLocationTypeDelegate] content] addObject:locationType];
            [[[self dropLocationTypeDelegate] content] addObject:locationType];
            
            if ([locationType locationTypeId] == pickupLocationTypeId) {
                selPickupLocationType = locationType;
            }
            
            if ([locationType locationTypeId] == dropLocationTypeId) {
                selDropLocationType = locationType;
            }
        }];
        
        [[self pickupLocationTypePicker] reloadAllComponents];
        if(selPickupLocationType) {
            [[self pickupLocationTypePicker] selectRow:[[[self pickupLocationTypeDelegate] content] indexOfObject:selPickupLocationType] inComponent:0 animated:YES];
        }
        
        [[self dropLocationTypePicker] reloadAllComponents];
        if(selDropLocationType) {
            [[self dropLocationTypePicker] selectRow:[[[self dropLocationTypeDelegate] content] indexOfObject:selDropLocationType] inComponent:0 animated:YES];
        }
    }];
    
    [[self equipTypeTF] setText:[[self runEntity] equipmentType]];
    [[self trailerSwitch] setOn:[[self runEntity] isTrailerProvided]];
    [[self teamRunSwitch] setOn:[[self runEntity] isTeamRun]];
    [[self recurringSwitch] setOn:[[self runEntity] isRecurring]];
    [[self loadDescTF] setText:[[self runEntity] loadDescription]];
    [[self startDatePicker] setDate:([[self runEntity] runStartDate] ? [[self runEntity] runStartDate] : [NSDate date]) animated:YES];
    [[self endDatePicker] setDate:([[self runEntity] runEndDate] ? [[self runEntity] runEndDate] : [NSDate date]) animated:YES];
    
    [[self pickupContactTF] setText:[[self runEntity] pickupContactName]];
    [[self pickupContactPhoneTF] setText:[[self runEntity] pickupContactPhone]];
    
    Address* pickupAddr = [[self runEntity] pickupAddress];
    if(pickupAddr) {
        
        [[self pickupStreetAddressTF] setText:[pickupAddr address1]];
        [[self pickupCityTF] setText:[pickupAddr city]];
        [[self pickupStateTF] setText:[pickupAddr stateCode]];
        [[self pickupZipCodeTF] setText:[pickupAddr zipCode]];
    }
    
    [[self dropContactTF] setText:[[self runEntity] dropOffContactName]];
    [[self dropContactPhoneTF] setText:[[self runEntity] dropOffContactPhone]];
    
    Address* dropAddr = [[self runEntity] dropOffAddress];
    if(dropAddr) {
        
        [[self dropStreetAddressTF] setText:[dropAddr address1]];
        [[self dropCityTF] setText:[dropAddr city]];
        [[self dropStateTF] setText:[dropAddr stateCode]];
        [[self dropZipCodeTF] setText:[dropAddr zipCode]];
    }
    
    [[self spInstructionsTF] setText:[[self runEntity] specialInstructions]];
    [[self hiringCriteriaTF] setText:[[self runEntity] hiringCriteria]];
    [[self criminalBGSwitch] setOn:[[self runEntity] criminalBackgroundCheckRequired]];
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
    [self setRunTitleLabel: [BBHUtil makeLabelWithText: @"Run Title" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setRuntTitleTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self runTitleLabel]];
    [contentView addSubview:[self runtTitleTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDriverTypeLabel: [BBHUtil makeLabelWithText:@"Driver Type" frame:rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, pickerWidth, pickerHeight);
    [self setDriverTypePicker: [[UIPickerView alloc] initWithFrame:rect]];
    
    [[self driverTypePicker] setDelegate:[self driverTypeDelegate]];
    [[self driverTypePicker] setDataSource:[self driverTypeDelegate]];
    
    [contentView addSubview:[self driverTypeLabel]];
    [contentView addSubview:[self driverTypePicker]];
    
    orig.y += [[self driverTypePicker] frame].size.height + 8;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setEquipTypeLabel: [BBHUtil makeLabelWithText: @"Equipment Type" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setEquipTypeTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self equipTypeLabel]];
    [contentView addSubview:[self equipTypeTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setTrailerLabel: [BBHUtil makeLabelWithText:@"Is Trailer Provider ?" frame:rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setTrailerSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self trailerLabel]];
    [contentView addSubview:[self trailerSwitch]];
    
    [[self driverTypeDelegate] setOnSelect:^{
        
        DriverType* type = [[[self driverTypeDelegate] content] objectAtIndex:[[self driverTypePicker] selectedRowInComponent:0]];
        
        if(type && [[type driverTypeName] isEqualToString:@"Owner Operator"]) {
            
            [[self trailerSwitch] setEnabled:YES];
            [[self trailerSwitch] setSelected:YES];
            
        } else {
            
            [[self trailerSwitch] setEnabled:NO];
            [[self trailerSwitch] setSelected:NO];
        }
    }];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setTeamRunLabel: [BBHUtil makeLabelWithText:@"Team Run ?" frame:rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setTeamRunSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self teamRunLabel]];
    [contentView addSubview:[self teamRunSwitch]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setRecurringLabel: [BBHUtil makeLabelWithText:@"Recurring ?" frame:rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setRecurringSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self recurringLabel]];
    [contentView addSubview:[self recurringSwitch]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setFreqLabel: [BBHUtil makeLabelWithText:@"Frequency" frame:rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, pickerWidth, pickerHeight);
    [self setFreqPicker: [[UIPickerView alloc] initWithFrame:rect]];
    
    [[self freqPicker] setDelegate:[self frequencyDelegate]];
    [[self freqPicker] setDataSource:[self frequencyDelegate]];
    
    [contentView addSubview:[self freqLabel]];
    [contentView addSubview:[self freqPicker]];
    
    orig.y += [[self freqPicker] frame].size.height + 8.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDriverClassLabel: [BBHUtil makeLabelWithText:@"Driver Class" frame:rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, pickerWidth, pickerHeight);
    [self setDriverClassPicker: [[UIPickerView alloc] initWithFrame:rect]];
    
    [[self driverClassPicker] setDelegate:[self driverClassDelegate]];
    [[self driverClassPicker] setDataSource:[self driverClassDelegate]];
    
    [contentView addSubview:[self driverClassLabel]];
    [contentView addSubview:[self driverClassPicker]];
    
    orig.y += [[self driverClassPicker] frame].size.height + 8.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setLoadDescLabel: [BBHUtil makeLabelWithText:@"Load Description" frame:rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setLoadDescTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self loadDescLabel]];
    [contentView addSubview:[self loadDescTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setStartDateLabel: [BBHUtil makeLabelWithText:@"Run Start Date" frame:rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, pickerWidth, pickerHeight);
    [self setStartDatePicker: [[UIDatePicker alloc] initWithFrame:rect]];
    
    [[self startDatePicker] setDatePickerMode:UIDatePickerModeDateAndTime];
    
    [contentView addSubview:[self startDateLabel]];
    [contentView addSubview:[self startDatePicker]];
    
    orig.y += [[self startDatePicker] frame].size.height + 8.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setEndDateLabel: [BBHUtil makeLabelWithText:@"Run End Date" frame:rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, pickerWidth, pickerHeight);
    [self setEndDatePicker: [[UIDatePicker alloc] initWithFrame:rect]];
    
    [[self endDatePicker] setDatePickerMode:UIDatePickerModeDateAndTime];
    
    [contentView addSubview:[self endDateLabel]];
    [contentView addSubview:[self endDatePicker]];
    
    orig.y += [[self endDatePicker] frame].size.height + 8.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    UILabel* pickupLocLabel = [BBHUtil makeLabelWithText:@"Pickup Location" frame:rect];
    
    [pickupLocLabel setTextColor:[BBHUtil headerTextColor]];
    [pickupLocLabel setFont:[UIFont systemFontOfSize:[[[pickupLocLabel font] fontDescriptor] pointSize] * 1.10]];
    
    [contentView addSubview:pickupLocLabel];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setPickupContactLabel: [BBHUtil makeLabelWithText: @"Contact Name" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setPickupContactTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self pickupContactLabel]];
    [contentView addSubview:[self pickupContactTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setPickupContactPhoneLabel: [BBHUtil makeLabelWithText: @"Contact Phone" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setPickupContactPhoneTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self pickupContactPhoneLabel]];
    [contentView addSubview:[self pickupContactPhoneTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setPickupLocationTypeLabel: [BBHUtil makeLabelWithText: @"Location Type" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, pickerWidth, pickerHeight);
    [self setPickupLocationTypePicker: [[UIPickerView alloc] initWithFrame:rect]];
    
    [[self pickupLocationTypePicker] setDelegate:[self pickupLocationTypeDelegate]];
    [[self pickupLocationTypePicker] setDataSource:[self pickupLocationTypeDelegate]];
    
    [contentView addSubview:[self pickupLocationTypeLabel]];
    [contentView addSubview:[self pickupLocationTypePicker]];
    
    orig.y += [[self pickupLocationTypePicker] frame].size.height + 8.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setPickupStreetAddressLabel: [BBHUtil makeLabelWithText: @"Street Address" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setPickupStreetAddressTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self pickupStreetAddressLabel]];
    [contentView addSubview:[self pickupStreetAddressTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setPickupZipCodeLabel: [BBHUtil makeLabelWithText: @"Zip Code" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setPickupZipCodeTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self pickupZipCodeLabel]];
    [contentView addSubview:[self pickupZipCodeTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setPickupCityLabel: [BBHUtil makeLabelWithText: @"City" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setPickupCityTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self pickupCityLabel]];
    [contentView addSubview:[self pickupCityTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setPickupStateLabel: [BBHUtil makeLabelWithText: @"State Code" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setPickupStateTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self pickupStateLabel]];
    [contentView addSubview:[self pickupStateTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    UILabel* dropLocLabel = [BBHUtil makeLabelWithText:@"Drop Location" frame:rect];
    
    [dropLocLabel setTextColor:[BBHUtil headerTextColor]];
    [dropLocLabel setFont:[UIFont systemFontOfSize:[[[pickupLocLabel font] fontDescriptor] pointSize] * 1.10]];
    
    [contentView addSubview:dropLocLabel];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDropContactLabel: [BBHUtil makeLabelWithText: @"Contact Name" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setDropContactTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self dropContactLabel]];
    [contentView addSubview:[self dropContactTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDropContactPhoneLabel: [BBHUtil makeLabelWithText: @"Contact Phone" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setDropContactPhoneTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self dropContactPhoneLabel]];
    [contentView addSubview:[self dropContactPhoneTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDropLocationTypeLabel: [BBHUtil makeLabelWithText: @"Location Type" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, pickerWidth, pickerHeight);
    [self setDropLocationTypePicker: [[UIPickerView alloc] initWithFrame:rect]];
    
    [[self dropLocationTypePicker] setDelegate:[self dropLocationTypeDelegate]];
    [[self dropLocationTypePicker] setDataSource:[self dropLocationTypeDelegate]];
    
    [contentView addSubview:[self dropLocationTypeLabel]];
    [contentView addSubview:[self dropLocationTypePicker]];
    
    orig.y += [[self dropLocationTypePicker] frame].size.height + 8.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDropStreetAddressLabel: [BBHUtil makeLabelWithText: @"Street Address" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setDropStreetAddressTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self dropStreetAddressLabel]];
    [contentView addSubview:[self dropStreetAddressTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDropZipCodeLabel: [BBHUtil makeLabelWithText: @"Zip Code" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setDropZipCodeTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self dropZipCodeLabel]];
    [contentView addSubview:[self dropZipCodeTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDropCityLabel: [BBHUtil makeLabelWithText: @"City" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setDropCityTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self dropCityLabel]];
    [contentView addSubview:[self dropCityTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setDropStateLabel: [BBHUtil makeLabelWithText: @"State Code" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setDropStateTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self dropStateLabel]];
    [contentView addSubview:[self dropStateTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setSpInstructionsLabel: [BBHUtil makeLabelWithText: @"Special Instructions" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setSpInstructionsTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self spInstructionsLabel]];
    [contentView addSubview:[self spInstructionsTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setHiringCriteriaLabel: [BBHUtil makeLabelWithText: @"Hiring Criteria" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setHiringCriteriaTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self hiringCriteriaLabel]];
    [contentView addSubview:[self hiringCriteriaTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setCriminalBGLabel: [BBHUtil makeLabelWithText: @"Criminal Background Check" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    [self setCriminalBGSwitch: [[UISwitch alloc] initWithFrame:rect]];
    
    [contentView addSubview:[self criminalBGLabel]];
    [contentView addSubview:[self criminalBGSwitch]];
    
    orig.y += 38.0;
    
    //[[self scrollView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[[self scrollView] setFrame:CGRectMake(0.0, 0.0, 600.0, 600.0)];
    
    [[self scrollView] setContentSize:CGSizeMake([[self view] frame].size.width, orig.y+150.0)];
    [[self scrollView] addSubview:contentView];
}

-(void)confirmSave:(void (^)(ConfirmResponse))handler {
    
    [BBHUtil showAlert:self handler:handler];
}

-(void) saveInfo {
    
    NSLog(@"Saving General Info");
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