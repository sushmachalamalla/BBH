//
//  TimeCardDateCell.m
//  BBH Mobile
//
//  Created by Mac-Mini on 11/25/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeCardExpenseCell.h"

@implementation TimeCardExpenseCell

@synthesize isUIDone;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        [self makeUI];
    }
    
    return self;
}

-(void)updateConstraints {
    
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo([self contentView].mas_left).with.offset([self separatorInset].left);
        make.centerY.equalTo([self contentView].mas_centerY);
        make.width.equalTo([self contentView].mas_width).with.multipliedBy(0.40);
    }];
    
    [_estAmtLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_nameLabel.mas_right).with.offset(2.0);
        make.centerY.equalTo([self contentView].mas_centerY);
        make.width.equalTo([self contentView].mas_width).with.multipliedBy(0.20);
    }];
    
    [_actualAmtLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_estAmtLabel.mas_right).with.offset(2.0);
        make.centerY.equalTo([self contentView].mas_centerY);
        make.width.equalTo([self contentView].mas_width).with.multipliedBy(0.20);
    }];
    
    [super updateConstraints];
}

-(void)makeUI {
    
    [self setNameLabel:[BBHUtil makeLabelWithText:@"Description"]];
    [self setEstAmtLabel:[BBHUtil makeLabelWithText:@"Estimate"]];
    [self setActualAmtLabel:[BBHUtil makeLabelWithText:@"Actual"]];
    
    [[self nameLabel] setTextAlignment:NSTextAlignmentLeft];
    [[self estAmtLabel] setTextAlignment:NSTextAlignmentRight];
    [[self actualAmtLabel] setTextAlignment:NSTextAlignmentRight];
    
    [[self contentView] addSubview:[self nameLabel]];
    [[self contentView] addSubview:[self estAmtLabel]];
    [[self contentView] addSubview:[self actualAmtLabel]];
}

@end