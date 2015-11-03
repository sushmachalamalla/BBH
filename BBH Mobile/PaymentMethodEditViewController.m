//
//  PaymentMethodEditViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 11/2/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentMethodEditViewController.h"

@implementation PaymentMethodEditViewController

@synthesize mode;

-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeUI];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self populate];
    [self presentViewController:[self editController] animated:YES completion:^{
        
        NSLog(@">> Done editing");
    }];
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

-(void) populate {
    //
}

-(void) makeUI {
    
    [self setEditController: [[UIViewController alloc] init]];
    UIView* contentView = [[self editController] view];
    
    CGPoint orig = CGPointMake(20.0, 28.0);
    
    CGFloat labelWidth = 266.0;
    CGFloat labelHeight = 21.0;
    
    CGFloat tfWidth = 584.0;
    CGFloat tfHeight = 30.0;
    
    //CGFloat pickerWidth = 300.0;
    //CGFloat pickerHeight = 100.0;
    
    CGRect rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setPmNameLabel: [BBHUtil makeLabelWithText: @"Payment Method Name" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setPmNameTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self pmNameLabel]];
    [contentView addSubview:[self pmNameTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setPmUnitLabel: [BBHUtil makeLabelWithText: @"Units" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setPmUnitTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self pmUnitLabel]];
    [contentView addSubview:[self pmUnitTF]];
    
    orig.y += 38.0;
    rect = CGRectMake(orig.x, orig.y, labelWidth, labelHeight);
    [self setPmCostLabel: [BBHUtil makeLabelWithText: @"Cost" frame: rect]];
    
    orig.y += 29.0;
    rect = CGRectMake(orig.x, orig.y, tfWidth, tfHeight);
    [self setPmCostTF: [BBHUtil makeTextFieldWithText:nil frame:rect]];
    
    [contentView addSubview:[self pmCostLabel]];
    [contentView addSubview:[self pmCostTF]];
}

-(void)saveInfo {
    //
}

-(void)confirmSave:(void (^)(ConfirmResponse))handler {
    //
}

@end