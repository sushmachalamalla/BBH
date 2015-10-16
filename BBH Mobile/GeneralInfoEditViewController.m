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

-(void)viewDidAppear:(BOOL)animated {
    
    [[self scrollView] flashScrollIndicators];
}

-(void)viewDidLoad {
    
    [self setDriverTypeDelegate:[[PickerDelegate alloc] init]];
    [self setFrequencyDelegate:[[PickerDelegate alloc] init]];
    [self setDriverClassDelegate:[[PickerDelegate alloc] init]];
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 600.0, 600.0)];
    
    CGPoint orig = CGPointMake(8.0, 8.0);
    
    CGFloat labelWidth = 266.0;
    CGFloat labelHeight = 21.0;
    
    CGFloat tfWidth = 584.0;
    CGFloat tfHeight = 30.0;
    
    CGRect rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    UILabel* runTitleLabel = [self makeLabelWithText: @"Run Title" frame: rect];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    UITextField* runtTitleTF = [self makeTextFieldWithText:nil frame:rect];
    
    [contentView addSubview:runTitleLabel];
    [contentView addSubview:runtTitleTF];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    UILabel* driverTypeLabel = [self makeLabelWithText:@"Driver Type" frame:rect];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 150.0, 50.0);
    UIPickerView* driverTypePicker = [[UIPickerView alloc] initWithFrame:rect];
    
    [driverTypePicker setDelegate:[self driverTypeDelegate]];
    [driverTypePicker setDataSource:[self driverTypeDelegate]];
    
    [contentView addSubview:driverTypeLabel];
    [contentView addSubview:driverTypePicker];
    
    orig.y += [driverTypePicker frame].size.height + 8;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    UILabel* equipTypeLabel = [self makeLabelWithText: @"Equipment Type" frame: rect];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    UITextField* equipTypeTF = [self makeTextFieldWithText:nil frame:rect];
    
    [contentView addSubview:equipTypeLabel];
    [contentView addSubview:equipTypeTF];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    UILabel* trailerLabel = [self makeLabelWithText:@"Is Trailer Provider ?" frame:rect];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    __block UISwitch* trailerSwitch = [[UISwitch alloc] initWithFrame:rect];
    
    [contentView addSubview:trailerLabel];
    [contentView addSubview:trailerSwitch];
    
    [[self driverTypeDelegate] setOnSelect:^{
        
        DriverType* type = [[self driverTypeDelegate] selected];
        if(type && [[type driverTypeName] isEqualToString:@"Owner Operator"]) {
            
            [trailerSwitch setEnabled:YES];
            [trailerSwitch setSelected:YES];
            
        } else {
            
            [trailerSwitch setEnabled:NO];
            [trailerSwitch setSelected:NO];
        }
    }];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    UILabel* teamRunLabel = [self makeLabelWithText:@"Team Run ?" frame:rect];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    __block UISwitch* teamRunSwitch = [[UISwitch alloc] initWithFrame:rect];
    
    [contentView addSubview:teamRunLabel];
    [contentView addSubview:teamRunSwitch];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    UILabel* recurringLabel = [self makeLabelWithText:@"Recurring ?" frame:rect];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 50.0, 30.0);
    __block UISwitch* recurringSwitch = [[UISwitch alloc] initWithFrame:rect];
    
    [contentView addSubview:recurringLabel];
    [contentView addSubview:recurringSwitch];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    UILabel* freqLabel = [self makeLabelWithText:@"Frequency" frame:rect];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 150.0, 50.0);
    UIPickerView* freqPicker = [[UIPickerView alloc] initWithFrame:rect];
    
    [freqPicker setDelegate:[self frequencyDelegate]];
    [freqPicker setDataSource:[self frequencyDelegate]];
    
    [contentView addSubview:freqLabel];
    [contentView addSubview:freqPicker];
    
    orig.y += [freqPicker frame].size.height + 8.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    UILabel* driverClassLabel = [self makeLabelWithText:@"Driver Class" frame:rect];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, 150.0, 50.0);
    UIPickerView* driverClassPicker = [[UIPickerView alloc] initWithFrame:rect];
    
    [driverClassPicker setDelegate:[self driverClassDelegate]];
    [driverClassPicker setDataSource:[self driverClassDelegate]];
    
    [contentView addSubview:driverClassLabel];
    [contentView addSubview:driverClassPicker];
    
    orig.y += [freqPicker frame].size.height;
    //[[self scrollView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[[self scrollView] setFrame:CGRectMake(0.0, 0.0, 600.0, 600.0)];
    [[self scrollView] setContentSize:CGSizeMake(600.0, orig.y+50.0)];
    [[self scrollView] addSubview:contentView];
}

-(UILabel*) makeLabelWithText: (NSString*)text frame:(CGRect)rect {
    
    UILabel* label = [[UILabel alloc] initWithFrame:rect];
    [label setText:text];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:15.0]];
    
    return label;
}

-(UITextField*) makeTextFieldWithText: (NSString*)text frame: (CGRect)rect {
    
    UITextField* tf = [[UITextField alloc] initWithFrame:rect];
    
    if (text) {
        [tf setPlaceholder:text];
    }
    
    [tf setBorderStyle:UITextBorderStyleRoundedRect];
    
    return tf;
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