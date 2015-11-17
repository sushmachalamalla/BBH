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

-(void)viewWillAppear:(BOOL)animated {
    
    [[[self navigationController] navigationBar] setTranslucent:NO];
}

-(void)viewDidLoad {
    
    /*[[self scrollView] setScrollEnabled:YES];
    [[self scrollView] setDelegate:self];
    
    [[self scrollView] flashScrollIndicators];*/
    
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
    
    [client doGETWithURL:@"driverTypes" params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
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
        if(selDriverType) {
            [[self driverTypePicker] selectRow:[[[self driverTypeDelegate] content] indexOfObject:selDriverType] inComponent:0 animated:YES];
        }
    }];
    
    int frequencyId = [[[self runEntity] runFrequency] runFrequencyId];
    __block RunFrequency* selFrequency = nil;
    
    [client doGETWithURL:@"runFrequencies" params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
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
    
    [client doGETWithURL:@"driverClasses" params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
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
    
    [client doGETWithURL:@"locationTypes" params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
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
    [[self startDatePicker] setDate:[[self runEntity] runStartDate] animated:YES];
    [[self endDatePicker] setDate:[[self runEntity] runEndDate] animated:YES];
    
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
    
    [[self view] setNeedsUpdateConstraints];
}

-(void)updateViewConstraints {
    
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
        make.width.equalTo([self view].mas_width).with.offset(-10.0);
    }];
    
    NSArray* array = [[NSArray alloc] initWithObjects:[self runTitleLabel], [self runtTitleTF], [self driverTypeLabel], [self driverTypePicker], [self equipTypeLabel], [self equipTypeTF], [self trailerLabel], [self trailerSwitch], [self teamRunLabel], [self teamRunSwitch], [self recurringLabel], [self recurringSwitch], [self freqLabel], [self freqPicker], [self driverClassLabel], [self driverClassPicker], [self loadDescLabel], [self loadDescTF], [self startDateLabel], [self startDatePicker], [self endDateLabel], [self endDatePicker], [self pickupLocLabel], [self pickupContactLabel], [self pickupContactTF], [self pickupContactPhoneLabel], [self pickupContactPhoneTF], [self pickupLocationTypeLabel], [self pickupLocationTypePicker], [self pickupStreetAddressLabel], [self pickupStreetAddressTF], [self pickupCityLabel], [self pickupCityTF], [self pickupStateLabel], [self pickupStateTF], [self pickupZipCodeLabel], [self pickupZipCodeTF], [self dropLocLabel], [self dropContactLabel], [self dropContactTF], [self dropContactPhoneLabel], [self dropContactPhoneTF], [self dropLocationTypeLabel], [self dropLocationTypePicker], [self dropStreetAddressLabel], [self dropStreetAddressTF], [self dropCityLabel], [self dropCityTF], [self dropStateLabel], [self dropStateTF], [self dropZipCodeLabel], [self dropZipCodeTF],[self spInstructionsLabel], [self spInstructionsTF], [self hiringCriteriaLabel], [self hiringCriteriaTF], [self criminalBGLabel], [self criminalBGSwitch], nil];
    
    CGPoint offset = CGPointMake(5.0, 5.0);
    [BBHUtil makeStackEdit:array superview:contentView offset:offset];
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        //make.right.equalTo([self runTitleLabel]).with.offset(10.0);
        make.bottom.equalTo([self criminalBGSwitch].mas_bottom).with.offset(10.0);
    }];
    
    [super updateViewConstraints];
}

-(void) makeUI {
    
    UIView* contentView = [[UIView alloc] init];
    
    [self setRunTitleLabel: [BBHUtil makeLabelWithText: @"Run Title"]];
    [self setRuntTitleTF: [BBHUtil makeTextFieldWithText:@"Run Title"]];
    
    [contentView addSubview:[self runTitleLabel]];
    [contentView addSubview:[self runtTitleTF]];
    
    [self setDriverTypeLabel: [BBHUtil makeLabelWithText:@"Driver Type"]];
    [self setDriverTypePicker: [[UIPickerView alloc] init]];
    
    [[self driverTypePicker] setDelegate:[self driverTypeDelegate]];
    [[self driverTypePicker] setDataSource:[self driverTypeDelegate]];
    
    [contentView addSubview:[self driverTypeLabel]];
    [contentView addSubview:[self driverTypePicker]];
    
    [self setEquipTypeLabel: [BBHUtil makeLabelWithText: @"Equipment Type"]];
    [self setEquipTypeTF: [BBHUtil makeTextFieldWithText:@"Equipment Type"]];
    
    [contentView addSubview:[self equipTypeLabel]];
    [contentView addSubview:[self equipTypeTF]];
    
    [self setTrailerLabel: [BBHUtil makeLabelWithText:@"Is Trailer Provider ?"]];
    [self setTrailerSwitch: [[UISwitch alloc] init]];
    
    [contentView addSubview:[self trailerLabel]];
    [contentView addSubview:[self trailerSwitch]];
    
    [[self driverTypeDelegate] setOnSelect:^{
        
        DriverType* type = [[[self driverTypeDelegate] content] objectAtIndex:[[self driverTypePicker] selectedRowInComponent:0]];
        
        if(type && [[type driverTypeName] isEqualToString:@"Owner Operator"]) {
            
            [[self trailerSwitch] setEnabled:YES];
            [[self trailerSwitch] setOn:YES];
            
        } else {
            
            [[self trailerSwitch] setEnabled:NO];
            [[self trailerSwitch] setOn:NO];
        }
    }];
    
    [self setTeamRunLabel: [BBHUtil makeLabelWithText:@"Team Run ?"]];
    [self setTeamRunSwitch: [[UISwitch alloc] init]];
    
    [contentView addSubview:[self teamRunLabel]];
    [contentView addSubview:[self teamRunSwitch]];
    
    [self setRecurringLabel: [BBHUtil makeLabelWithText:@"Recurring ?"]];
    [self setRecurringSwitch: [[UISwitch alloc] init]];
    
    [contentView addSubview:[self recurringLabel]];
    [contentView addSubview:[self recurringSwitch]];
    
    [self setFreqLabel: [BBHUtil makeLabelWithText:@"Frequency"]];
    [self setFreqPicker: [[UIPickerView alloc] init]];
    
    [[self freqPicker] setDelegate:[self frequencyDelegate]];
    [[self freqPicker] setDataSource:[self frequencyDelegate]];
    
    [contentView addSubview:[self freqLabel]];
    [contentView addSubview:[self freqPicker]];
    
    [self setDriverClassLabel: [BBHUtil makeLabelWithText:@"Driver Class"]];
    [self setDriverClassPicker: [[UIPickerView alloc] init]];
    
    [[self driverClassPicker] setDelegate:[self driverClassDelegate]];
    [[self driverClassPicker] setDataSource:[self driverClassDelegate]];
    
    [contentView addSubview:[self driverClassLabel]];
    [contentView addSubview:[self driverClassPicker]];
    
    [self setLoadDescLabel: [BBHUtil makeLabelWithText:@"Load Description"]];
    [self setLoadDescTF: [BBHUtil makeTextFieldWithText:@"Load Description"]];
    
    [contentView addSubview:[self loadDescLabel]];
    [contentView addSubview:[self loadDescTF]];
    
    [self setStartDateLabel: [BBHUtil makeLabelWithText:@"Run Start Date"]];
    [self setStartDatePicker: [[UIDatePicker alloc] init]];
    
    [[self startDatePicker] setDatePickerMode:UIDatePickerModeDate];
    
    [contentView addSubview:[self startDateLabel]];
    [contentView addSubview:[self startDatePicker]];
    
    [self setEndDateLabel: [BBHUtil makeLabelWithText:@"Run End Date"]];
    [self setEndDatePicker: [[UIDatePicker alloc] init]];
    
    [[self endDatePicker] setDatePickerMode:UIDatePickerModeDate];
    
    [contentView addSubview:[self endDateLabel]];
    [contentView addSubview:[self endDatePicker]];
    
    UILabel* pickupLocLabel = [BBHUtil makeLabelWithText:@"Pickup Location"];
    
    [pickupLocLabel setTextColor:[BBHUtil headerTextColor]];
    [pickupLocLabel setFont:[UIFont systemFontOfSize:[[[pickupLocLabel font] fontDescriptor] pointSize] * 1.10]];
    
    [self setPickupLocLabel:pickupLocLabel];
    [contentView addSubview:pickupLocLabel];
    
    [self setPickupContactLabel: [BBHUtil makeLabelWithText: @"Contact Name"]];
    [self setPickupContactTF: [BBHUtil makeTextFieldWithText:@"Contact Name"]];
    
    [contentView addSubview:[self pickupContactLabel]];
    [contentView addSubview:[self pickupContactTF]];
    
    [self setPickupContactPhoneLabel: [BBHUtil makeLabelWithText: @"Contact Phone"]];
    [self setPickupContactPhoneTF: [BBHUtil makeTextFieldWithText:@"Contact Phone"]];
    
    [contentView addSubview:[self pickupContactPhoneLabel]];
    [contentView addSubview:[self pickupContactPhoneTF]];
    
    [self setPickupLocationTypeLabel: [BBHUtil makeLabelWithText: @"Location Type"]];
    [self setPickupLocationTypePicker: [[UIPickerView alloc] init]];
    
    [[self pickupLocationTypePicker] setDelegate:[self pickupLocationTypeDelegate]];
    [[self pickupLocationTypePicker] setDataSource:[self pickupLocationTypeDelegate]];
    
    [contentView addSubview:[self pickupLocationTypeLabel]];
    [contentView addSubview:[self pickupLocationTypePicker]];
    
    [self setPickupStreetAddressLabel: [BBHUtil makeLabelWithText: @"Street Address"]];
    [self setPickupStreetAddressTF: [BBHUtil makeTextFieldWithText:@"Street Address"]];
    
    [contentView addSubview:[self pickupStreetAddressLabel]];
    [contentView addSubview:[self pickupStreetAddressTF]];
    
    [self setPickupZipCodeLabel: [BBHUtil makeLabelWithText: @"Zip Code"]];
    [self setPickupZipCodeTF: [BBHUtil makeTextFieldWithText:@"Zip Code"]];
    
    [contentView addSubview:[self pickupZipCodeLabel]];
    [contentView addSubview:[self pickupZipCodeTF]];
    
    [self setPickupCityLabel: [BBHUtil makeLabelWithText: @"City"]];
    [self setPickupCityTF: [BBHUtil makeTextFieldWithText:@"City"]];
    
    [contentView addSubview:[self pickupCityLabel]];
    [contentView addSubview:[self pickupCityTF]];
    
    [self setPickupStateLabel: [BBHUtil makeLabelWithText: @"State Code"]];
    [self setPickupStateTF: [BBHUtil makeTextFieldWithText:@"State Code"]];
    
    [contentView addSubview:[self pickupStateLabel]];
    [contentView addSubview:[self pickupStateTF]];
    
    UILabel* dropLocLabel = [BBHUtil makeLabelWithText:@"Drop Location"];
    
    [dropLocLabel setTextColor:[BBHUtil headerTextColor]];
    [dropLocLabel setFont:[UIFont systemFontOfSize:[[[pickupLocLabel font] fontDescriptor] pointSize] * 1.10]];
    
    [self setDropLocLabel:dropLocLabel];
    [contentView addSubview:dropLocLabel];
    
    [self setDropContactLabel: [BBHUtil makeLabelWithText: @"Contact Name"]];
    [self setDropContactTF: [BBHUtil makeTextFieldWithText:@"Contact Name"]];
    
    [contentView addSubview:[self dropContactLabel]];
    [contentView addSubview:[self dropContactTF]];
    
    [self setDropContactPhoneLabel: [BBHUtil makeLabelWithText: @"Contact Phone"]];
    [self setDropContactPhoneTF: [BBHUtil makeTextFieldWithText:@"Contact Phone"]];
    
    [contentView addSubview:[self dropContactPhoneLabel]];
    [contentView addSubview:[self dropContactPhoneTF]];
    
    [self setDropLocationTypeLabel: [BBHUtil makeLabelWithText: @"Location Type"]];
    [self setDropLocationTypePicker: [[UIPickerView alloc] init]];
    
    [[self dropLocationTypePicker] setDelegate:[self dropLocationTypeDelegate]];
    [[self dropLocationTypePicker] setDataSource:[self dropLocationTypeDelegate]];
    
    [contentView addSubview:[self dropLocationTypeLabel]];
    [contentView addSubview:[self dropLocationTypePicker]];
    
    [self setDropStreetAddressLabel: [BBHUtil makeLabelWithText: @"Street Address"]];
    [self setDropStreetAddressTF: [BBHUtil makeTextFieldWithText:@"Street Address"]];
    
    [contentView addSubview:[self dropStreetAddressLabel]];
    [contentView addSubview:[self dropStreetAddressTF]];
    
    [self setDropZipCodeLabel: [BBHUtil makeLabelWithText: @"Zip Code"]];
    [self setDropZipCodeTF: [BBHUtil makeTextFieldWithText:@"Zip Code"]];
    
    [contentView addSubview:[self dropZipCodeLabel]];
    [contentView addSubview:[self dropZipCodeTF]];
    
    [self setDropCityLabel: [BBHUtil makeLabelWithText: @"City"]];
    [self setDropCityTF: [BBHUtil makeTextFieldWithText:@"City"]];
    
    [contentView addSubview:[self dropCityLabel]];
    [contentView addSubview:[self dropCityTF]];
    
    [self setDropStateLabel: [BBHUtil makeLabelWithText: @"State Code"]];
    [self setDropStateTF: [BBHUtil makeTextFieldWithText:@"State Code"]];
    
    [contentView addSubview:[self dropStateLabel]];
    [contentView addSubview:[self dropStateTF]];
    
    [self setSpInstructionsLabel: [BBHUtil makeLabelWithText: @"Special Instructions"]];
    [self setSpInstructionsTF: [BBHUtil makeTextFieldWithText:@"Special Instructions"]];
    
    [contentView addSubview:[self spInstructionsLabel]];
    [contentView addSubview:[self spInstructionsTF]];
    
    [self setHiringCriteriaLabel: [BBHUtil makeLabelWithText: @"Hiring Criteria"]];
    [self setHiringCriteriaTF: [BBHUtil makeTextFieldWithText:@"Hiring Criteria"]];
    
    [contentView addSubview:[self hiringCriteriaLabel]];
    [contentView addSubview:[self hiringCriteriaTF]];
    
    [self setCriminalBGLabel: [BBHUtil makeLabelWithText: @"Criminal Background Check"]];
    [self setCriminalBGSwitch: [[UISwitch alloc] init]];
    
    [contentView addSubview:[self criminalBGLabel]];
    [contentView addSubview:[self criminalBGSwitch]];
    
    [self setScrollView:[[UIScrollView alloc] init]];
    [[self scrollView] setScrollEnabled:YES];
    [[self scrollView] setPagingEnabled:NO];
    [[self scrollView] setDelegate:self];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [[self scrollView] addSubview:contentView];
    [[self view] addSubview:[self scrollView]];
}

-(void)confirmSave:(void (^)(ConfirmResponse))handler {
    
    [BBHUtil showAlert:self handler:handler];
}

-(void) saveInfo {
    
    //NSLog(@" xxxxxxxxxxxx %@", [[self runEntity] links]);
    Run* run = [[Run alloc] initWithDict:[[self runEntity] exportToDict]];
    
    NSString* runTitle = [[self runtTitleTF] text];
    DriverType* driverType = [[[self driverTypeDelegate] content] objectAtIndex:[[self driverTypePicker] selectedRowInComponent:0]];
    
    NSString* equipmentType = [[self equipTypeTF] text];
    
    BOOL trailer = [[self trailerSwitch] isOn];
    BOOL teamRun = [[self teamRunSwitch] isOn];
    BOOL recurring = [[self recurringSwitch] isOn];
    
    RunFrequency* frequency = [[[self frequencyDelegate] content] objectAtIndex:[[self freqPicker] selectedRowInComponent:0]];
    
    DriverClass* driverClass = [[[self driverClassDelegate] content] objectAtIndex:[[self driverClassPicker] selectedRowInComponent:0]];
    
    NSString* loadDesc = [[self loadDescTF] text];
    NSDate* startDate = [[self startDatePicker] date];
    NSDate* endDate = [[self endDatePicker] date];
    
    NSString* pickupContactName = [[self pickupContactTF] text];
    NSString* pickupContactPhone = [[self pickupContactPhoneTF] text];
    
    NSString* pickupStreetAddr = [[self pickupStreetAddressTF] text];
    NSString* pickupCity = [[self pickupCityTF] text];
    NSString* pickupState = [[self pickupStateTF] text];
    NSString* pickupZipCode = [[self pickupZipCodeTF] text];
    
    LocationType* pickupLocationType = [[[self dropLocationTypeDelegate] content] objectAtIndex:[[self dropLocationTypePicker] selectedRowInComponent:0]];
    
    NSString* dropContactName = [[self dropContactTF] text];
    NSString* dropContactPhone = [[self dropContactPhoneTF] text];
    
    NSString* dropStreetAddr = [[self dropStreetAddressTF] text];
    NSString* dropCity = [[self dropCityTF] text];
    NSString* dropState = [[self dropStateTF] text];
    NSString* dropZipCode = [[self dropZipCodeTF] text];
    
    LocationType* dropLocationType = [[[self dropLocationTypeDelegate] content] objectAtIndex:[[self dropLocationTypePicker] selectedRowInComponent:0]];
    
    [run setRunTitle: [BBHUtil isEmpty:runTitle] ? nil : runTitle];
    [run setDriverType:driverType];
    
    [run setEquipmentType:[BBHUtil isEmpty:equipmentType] ? nil : equipmentType];
    
    [run setIsTrailerProvided:trailer];
    [run setIsTeamRun:teamRun];
    [run setIsRecurring:recurring];
    
    [run setRunFrequency:frequency];
    [run setDriverClass:driverClass];
    
    [run setLoadDescription:[BBHUtil isEmpty:loadDesc] ? nil : loadDesc];
    [run setRunStartDate:startDate];
    [run setRunEndDate:endDate];
    
    [run setPickupLocationType:pickupLocationType];
    [run setPickupContactName:pickupContactName];
    [run setPickupContactPhone:pickupContactPhone];
    
    if(![BBHUtil isEmpty: pickupStreetAddr]) {
        
        if (![run pickupAddress]) {
            [run setPickupAddress:[[Address alloc] init]];
        }
        
        Address* addr = [run pickupAddress];
        [addr setAddress1:pickupStreetAddr];
        [addr setCity:[BBHUtil isEmpty:pickupCity] ? nil : pickupCity];
        [addr setStateCode:[BBHUtil isEmpty:pickupState] ? nil : pickupState];
        [addr setZipCode:[BBHUtil isEmpty:pickupZipCode] ? nil : pickupZipCode];
    }
    
    [run setDropOffLocationType:dropLocationType];
    [run setDropOffContactName:dropContactName];
    [run setDropOffContactPhone:dropContactPhone];
    
    if(![BBHUtil isEmpty: dropStreetAddr]) {
        
        if (![run dropOffAddress]) {
            [run setDropOffAddress:[[Address alloc] init]];
        }
        
        Address* addr = [run dropOffAddress];
        [addr setAddress1:dropStreetAddr];
        [addr setCity:[BBHUtil isEmpty:dropCity] ? nil : dropCity];
        [addr setStateCode:[BBHUtil isEmpty:dropState] ? nil : dropState];
        [addr setZipCode:[BBHUtil isEmpty:dropZipCode] ? nil : dropZipCode];
    }
    
    NSError* error = nil;
    NSDictionary* dict = [run exportToDict];
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    
    if(data && !error) {
        
        NSLog(@"Saving General Info: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        RESTClient* client = [RESTClient instance];
        Link* link = [[[self runEntity] links] valueForKey:@"updateRun"];
        
        [client doPUTWithURL:[link href] data:data complete:^(RESTResponse response, NSDictionary* dict) {
            
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