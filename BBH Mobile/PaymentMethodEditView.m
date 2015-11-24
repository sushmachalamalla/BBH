//
//  PaymentMethodEditView.m
//  BBH Mobile
//
//  Created by Mac-Mini on 11/19/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentMethodEditView.h"

@class PaymentMethodEditViewController;

@implementation PaymentMethodEditView

@synthesize mode;
@synthesize isClean;
@synthesize isUIDone;

- (instancetype)init {
    
    NSLog(@"++++++++ INIT");
    self = [super init];
    
    if(self) {
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
    }
    
    return self;
}

-(void)loadView {
    
    NSLog(@"+++++++++++++++ loadView");
    
    [self setView:[UIView new]];
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [[self view] setOpaque:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([self isUIDone]) {
        [self populate];
    }
}

-(void)viewDidLoad {
    
    [[self navigationItem] setTitle:([self mode] == EntityModeAdd ? @"Payment Method Add" : @"Payment Method Edit")];
    
    UIBarButtonItem* saveBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveInfo)];
    
    NSMutableArray* btnList = [NSMutableArray arrayWithArray:[[self navigationItem] leftBarButtonItems]];
    
    [btnList addObject:saveBtn];
    
    NSLog(@">>> BAR BTN ITEMS: %lu", (unsigned long)[btnList count]);
    
    [[self navigationItem] setLeftItemsSupplementBackButton:YES];
    [[self navigationItem] setLeftBarButtonItems:btnList];
    NSLog(@">>> BAR BTN ITEMS: %lu", (unsigned long)[[[self navigationItem] leftBarButtonItems] count]);
    
    [self makeUI];
    [self populate];
    [[self view] setNeedsUpdateConstraints];
}

-(void) updateViewConstraints {
    
    NSLog(@">>>>>>>>>>>> UPDATE CONSTRAINTS");;
    
    [[self contentView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo([self view]).with.insets(UIEdgeInsetsMake(0.0, 0.0, 0.0, 10.0));
    }];
    
    NSArray* array = [[NSArray alloc] initWithObjects:[self pmNameLabel], [self pmPicker], [self pmUnitLabel], [self pmUnitTF], [self pmCostLabel], [self pmCostTF], nil];
    
    [BBHUtil makeStackEdit:array superview:[self contentView] offset:CGPointMake(5.0, [BBHUtil statusBarHeight] + 5.0)];
    
    [super updateViewConstraints];
}

-(void)populate {
    
    RunPaymentMethod* rpm = [self pmEntity];
    
    [[self pmUnitTF] setText:nil];
    [[self pmCostTF] setText:nil];
    
    RESTClient* client = [RESTClient instance];
    
    __block PaymentMethod* selPm = nil;
    int pmId = [self mode] == EntityModeEdit ? [[rpm paymentMethod] paymentMethodId] : -1;
    
    [client doGETWithURL:@"paymentMethods" params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            //NSLog([NSString stringWithFormat:@"SUCCESS >> %@", data]);
            NSArray* types = [data valueForKey:@"PaymentMethods"];
            
            [types enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                PaymentMethod* pm = [[PaymentMethod alloc] initWithDict:obj];
                [[[self pmDelegate] content] addObject:pm];
                
                if ([pm paymentMethodId] == pmId) {
                    selPm = pm;
                }
            }];
            
            [[self pmPicker] reloadAllComponents];
            if(selPm) {
                [[self pmPicker] selectRow:[[[self pmDelegate] content] indexOfObject:selPm] inComponent:0 animated:YES];
            }
            
        } else {
            
            NSLog(@">> An error occured fetching payment methods");
        }
    }];
    
    if([self mode] == EntityModeEdit) {
        
        [[self pmUnitTF] setText:[NSString stringWithFormat:@"%.2f", [[rpm estimatedUnits] doubleValue]]];
        [[self pmCostTF] setText:[NSString stringWithFormat:@"%.2f", [[rpm estimatedRate] doubleValue]]];
    }
}

-(void) makeUI {
    
    [self setContentView:[UIView new]];
    
    [self setPmNameLabel: [BBHUtil makeLabelWithText: @"Payment Method"]];
    [self setPmPicker: [[UIPickerView alloc] init]];
    
    [self setPmDelegate:[[PickerDelegate alloc] init]];
    [[self pmDelegate] setOnSelect:^{
       //
    }];
    
    [[self pmPicker] setDelegate:[self pmDelegate]];
    
    [[self contentView] addSubview:[self pmNameLabel]];
    [[self contentView] addSubview:[self pmPicker]];
    
    [self setPmUnitLabel: [BBHUtil makeLabelWithText: @"Units"]];
    [self setPmUnitTF: [BBHUtil makeTextFieldWithText:@"Units"]];
    
    [[self contentView] addSubview:[self pmUnitLabel]];
    [[self contentView] addSubview:[self pmUnitTF]];
    
    [self setPmCostLabel: [BBHUtil makeLabelWithText: @"Cost"]];
    [self setPmCostTF: [BBHUtil makeTextFieldWithText:@"Cost"]];
    
    [[self contentView] addSubview:[self pmCostLabel]];
    [[self contentView] addSubview:[self pmCostTF]];
    
    [[self view] addSubview:[self contentView]];
    [self setIsUIDone:YES];
}

-(void)confirmSave:(void (^)(ConfirmResponse))handler {
    
    [BBHUtil showConfirmSave:self handler:handler];
}

-(void) saveInfo {
    
    RunPaymentMethod* rpm = [[RunPaymentMethod alloc] init];
    if ([self mode] == EntityModeEdit) {
        rpm = [rpm initWithDict:[[self pmEntity] exportToDict]];
    }
    
    PaymentMethod* pm = [[[self pmDelegate] content] objectAtIndex:[[self pmPicker] selectedRowInComponent:0]];
    
    NSString* sPmUnits = [[self pmUnitTF] text];
    NSString* sPmRate = [[self pmCostTF] text];
    
    NSNumber* pmUnits = nil;
    NSNumber* pmRate = nil;
    
    NSString* fieldName = nil;
    if (!pm) {
        
        fieldName = @"Payment Method";
        
    } else if([BBHUtil isEmpty:sPmUnits] || (pmUnits = [BBHUtil readDecimal:sPmUnits]) == nil || ([pmUnits doubleValue] < 0.0)) {
        
        fieldName = @"Est Units";
        
    } else if([BBHUtil isEmpty:sPmRate] || (pmRate = [BBHUtil readDecimal:sPmRate]) == nil || ([pmRate doubleValue] < 0.0)) {
        
        fieldName = @"Est Rate";
    }
    
    if (fieldName) {
        
        [BBHUtil showValidationAlert:self field:fieldName];
        return;
    }
    
    [rpm setPaymentMethod:pm];
    [rpm setEstimatedUnits:pmUnits];
    [rpm setEstimatedRate:pmRate];
    
    NSError* error = nil;
    NSDictionary* runPMDict = [rpm exportToDict];
    
    if ([self mode] == EntityModeAdd) {
        //[runPMDict setValue:[NSNull null] forKey:@"runPaymentMethodId"];
    }
    
    NSArray* pmList = [[NSArray alloc] initWithObjects:runPMDict, nil];
    NSDictionary* pmListJSON = [NSDictionary dictionaryWithObjectsAndKeys:pmList, @"RunPaymentMethods", nil];
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:pmListJSON options:kNilOptions error:&error];
    
    if(data && !error) {
        
        NSLog(@">> Saving PM: %@", pmListJSON);
        
        RESTClient* client = [RESTClient instance];
        
        NSString* link = [NSString stringWithFormat:@"runs/%d/runPaymentMethods", [[self runEntity] runId]];
        
        id handler = ^(RESTResponse response, NSDictionary* dict) {
            
            if(response == RESTResponseSuccess) {
                
                NSLog(@"Saved PM: %@", dict);
                [self setPmEntity: [[self pmEntity] initWithDict:[rpm exportToDict]]];
                [self setIsClean:YES];
                
            } else {
                
                NSLog(@"Error Saving PM: %@", dict);
            }
        };
        
        [client doPUTWithURL:link data:data complete:handler];
        
    } else {
        
        NSLog(@">> ERROR Saving PM !!");
    }
}

@end