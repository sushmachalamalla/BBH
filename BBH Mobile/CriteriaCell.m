//
//  CriteriaCell.m
//  BBH Mobile
//
//  Created by Mac-Mini on 11/22/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CriteriaCell.h"

@implementation SkillCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        [self makeUI];
    }
    
    return self;
}

-(void) makeUI {
    
    //[self setBackgroundColor:[UIColor redColor]];
    
    _skillLabel = [BBHUtil makeLabelWithText:@"-"];
    _yearSlotLabel = [BBHUtil makeLabelWithText:@"-"];
    
    [_skillLabel setTextColor:[UIColor grayColor]];
    [_yearSlotLabel setTextColor:[UIColor grayColor]];
    
    [_skillLabel setTextAlignment:NSTextAlignmentLeft];
    [_yearSlotLabel setTextAlignment:NSTextAlignmentRight];
    
    [[self contentView] addSubview:_skillLabel];
    [[self contentView] addSubview:_yearSlotLabel];
    [self setNeedsUpdateConstraints];
}

-(void)updateConstraints {
    
    [_skillLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo([self contentView].mas_left).with.offset([self separatorInset].left);
        make.centerY.equalTo([self contentView].mas_centerY);
        make.width.equalTo([self contentView].mas_width).with.multipliedBy(0.60);
    }];
    
    [_yearSlotLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_skillLabel.mas_right).with.offset(2.0);
        make.centerY.equalTo([self contentView].mas_centerY);
        make.width.equalTo([self contentView].mas_width).with.multipliedBy(0.20);
    }];
    
    [super updateConstraints];
}

@end

@implementation EquipmentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        [self makeUI];
    }
    
    return self;
}

-(void) makeUI {
    
    //[self setBackgroundColor:[UIColor redColor]];
    
    _equipmentLabel = [BBHUtil makeLabelWithText:@"-"];
    _yearSlotLabel = [BBHUtil makeLabelWithText:@"-"];
    
    [_equipmentLabel setTextColor:[UIColor grayColor]];
    [_yearSlotLabel setTextColor:[UIColor grayColor]];
    
    [_equipmentLabel setTextAlignment:NSTextAlignmentLeft];
    [_yearSlotLabel setTextAlignment:NSTextAlignmentRight];
    
    [[self contentView] addSubview:_equipmentLabel];
    [[self contentView] addSubview:_yearSlotLabel];
    
    [self setNeedsUpdateConstraints];
}

-(void)updateConstraints {
    
    [_equipmentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo([self contentView].mas_left).with.offset([self separatorInset].left);
        make.centerY.equalTo([self contentView].mas_centerY);
        make.width.equalTo([self contentView].mas_width).with.multipliedBy(0.60);
    }];
    
    [_yearSlotLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_equipmentLabel.mas_right).with.offset(2.0);
        make.centerY.equalTo([self contentView].mas_centerY);
        make.width.equalTo([self contentView].mas_width).with.multipliedBy(0.20);
    }];
    
    [super updateConstraints];
}

@end

@implementation EndorsementCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        [self makeUI];
    }
    
    return self;
}

-(void) makeUI {
    
    //[self setBackgroundColor:[UIColor redColor]];
    
    _endorsementLabel = [BBHUtil makeLabelWithText:@"-"];
    
    [[self contentView] addSubview:_endorsementLabel];
    
    [self setNeedsUpdateConstraints];
}

-(void)updateConstraints {
    
    [_endorsementLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo([self contentView].mas_left).with.offset([self separatorInset].left);
        make.centerY.equalTo([self contentView].mas_centerY);
        make.width.equalTo([self contentView].mas_width).with.multipliedBy(0.90);
    }];
    
    [super updateConstraints];
}

@end