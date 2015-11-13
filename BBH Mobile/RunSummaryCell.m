//
//  RunSummaryCell.m
//  BBH Mobile
//
//  Created by Mac-Mini on 9/29/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunSummaryCell.h"

@implementation RunSummaryCell

-(void)updateConstraints {
    
    //UIFont* textFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    UIView* view = [self contentView];
    
    __block CGPoint orig = CGPointMake(5.0, 15.0);
    
    __block NSArray* array = [NSArray arrayWithObjects: [self companyKeyLabel], [self runTitleKeyLabel], [self estPayKeyLabel], [self driverTypeKeyLabel], [self driverClassKeyLabel], nil];
    
    __block CGPoint bottomRight = [BBHUtil makeColumn: array withOrig:orig superview:view];
    
    orig.x = bottomRight.x + 10.0;
    array = [NSArray arrayWithObjects: [self companyLabel], [self runTitleLabel], [self estPayLabel], [self driverTypeLabel], [self driverClassLabel], nil];
    
    bottomRight = [BBHUtil makeColumn: array withOrig:orig superview:view];
    
    [[self pickupAddrView] setOpaque:YES];
    [view bringSubviewToFront:[self pickupAddrView]];
    [[self pickupAddrView] setBackgroundColor:[UIColor grayColor]];
    [[self pickupAddrView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(view.mas_top).with.offset(bottomRight.y + 10.0);
        make.left.equalTo(view.mas_left).with.offset(5.0);
        //make.width.equalTo(view.mas_width).multipliedBy(0.45);
    }];
    
    orig = CGPointMake(5.0, 5.0);
    array = [NSArray arrayWithObjects:[self pickupKeyLabel], [self pickupLocationLabel],[self pickupDateLabel],nil];
    
    [BBHUtil makeColumn:array withOrig:orig superview:[self pickupAddrView]];
    
    [[self dropAddrView] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [[self dropAddrView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self pickupAddrView].mas_top);
        make.left.equalTo([self pickupAddrView].mas_right).with.offset(5.0);
        make.right.equalTo(view.mas_right).with.offset(10.0);
        make.width.equalTo([self pickupAddrView].mas_width);
    }];
    
    array = [NSArray arrayWithObjects:[self dropKeyLabel], [self dropLocationLabel],[self dropDateLabel],nil];
    bottomRight = [BBHUtil makeColumn:array withOrig:orig superview:[self dropAddrView]];
    
    [super updateConstraints];
}

@end