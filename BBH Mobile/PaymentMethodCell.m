//
//  PaymentMethodCell.m
//  BBH Mobile
//
//  Created by Mac-Mini on 11/18/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentMethodCell.h"

@implementation PaymentMethodCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        [self makeUI];
    }
    
    return self;
}

-(void) makeUI {
    
    //[self setBackgroundColor:[UIColor redColor]];
    
    _pmLabel = [BBHUtil makeLabelWithText:@"-"];
    _unitLabel = [BBHUtil makeLabelWithText:@"-"];
    _rateLabel = [BBHUtil makeLabelWithText:@"-"];
    
    [_pmLabel setTextAlignment:NSTextAlignmentLeft];
    [_unitLabel setTextAlignment:NSTextAlignmentRight];
    [_rateLabel setTextAlignment:NSTextAlignmentRight];
    
    [_pmLabel setTextColor:[UIColor grayColor]];
    [_unitLabel setTextColor:[UIColor grayColor]];
    [_rateLabel setTextColor:[UIColor grayColor]];
    
    /*[_pmLabel setBackgroundColor:[UIColor redColor]];
    [_unitLabel setBackgroundColor:[UIColor greenColor]];
    [_rateLabel setBackgroundColor:[UIColor blueColor]];*/
    
    [[self contentView] addSubview:_pmLabel];
    [[self contentView] addSubview:_unitLabel];
    [[self contentView] addSubview:_rateLabel];
}

-(void)updateConstraints {
    
    [_pmLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo([self contentView].mas_left).with.offset([self separatorInset].left);
        make.centerY.equalTo([self contentView].mas_centerY);
        make.width.equalTo([self contentView].mas_width).with.multipliedBy(0.40);
    }];
    
    [_unitLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pmLabel.mas_right).with.offset(2.0);
        make.centerY.equalTo([self contentView].mas_centerY);
        make.width.equalTo([self contentView].mas_width).with.multipliedBy(0.20);
    }];
    
    [_rateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_unitLabel.mas_right).with.offset(2.0);
        make.centerY.equalTo([self contentView].mas_centerY);
        make.width.equalTo(_unitLabel.mas_width);
        //make.right.equalTo([cell contentView].mas_right).with.offset([cell separatorInset].right);
    }];
    
    [super updateConstraints];
}

@end