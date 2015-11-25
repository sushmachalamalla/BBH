//
//  TimeCardViewCell.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/8/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeCardViewCell.h"

@implementation TimeCardViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        [self makeUI];
    }
    
    return self;
}

-(void) makeUI {
    
    //[self setBackgroundColor:[UIColor redColor]];
    
    _nameKeyLabel = [BBHUtil makeLabelWithText:@"Name:"];
    _statusKeyLabel = [BBHUtil makeLabelWithText:@"Status:"];
    _approvedByKeyLabel = [BBHUtil makeLabelWithText:@"Approved By:"];
    _approvedDateKeyLabel = [BBHUtil makeLabelWithText:@"Approval Date:"];
    
    _nameLabel = [BBHUtil makeLabelWithText:@"-"];
    _statusLabel = [BBHUtil makeLabelWithText:@"-"];
    _approvedByLabel = [BBHUtil makeLabelWithText:@"-"];
    _approvedDateLabel = [BBHUtil makeLabelWithText:@"-"];
    
    [_nameKeyLabel setTextColor:[UIColor grayColor]];
    [_statusKeyLabel setTextColor:[UIColor grayColor]];
    [_approvedByKeyLabel setTextColor:[UIColor grayColor]];
    [_approvedDateKeyLabel setTextColor:[UIColor grayColor]];
    
    [_nameLabel setTextColor:[UIColor grayColor]];
    [_statusLabel setTextColor:[UIColor grayColor]];
    [_approvedByLabel setTextColor:[UIColor grayColor]];
    [_approvedDateLabel setTextColor:[UIColor grayColor]];
    
    [[self contentView] addSubview:_nameKeyLabel];
    [[self contentView] addSubview:_nameLabel];
    [[self contentView] addSubview:_statusKeyLabel];
    [[self contentView] addSubview:_statusLabel];
    [[self contentView] addSubview:_approvedByKeyLabel];
    [[self contentView] addSubview:_approvedByLabel];
    [[self contentView] addSubview:_approvedDateKeyLabel];
    [[self contentView] addSubview:_approvedDateLabel];
}

-(void)updateConstraints {
    
    NSArray* array = [[NSArray alloc] initWithObjects:[self nameKeyLabel], [self statusKeyLabel], [self approvedByKeyLabel], [self approvedDateKeyLabel],  nil];
    
    CGPoint offset = CGPointMake(5.0, 5.0);
    CGSize box = [BBHUtil makeStack:array superview:[self contentView] offset:offset];
    
    array = [[NSArray alloc] initWithObjects:[self nameLabel], [self statusLabel], [self approvedByLabel], [self approvedDateLabel],  nil];
    
    offset.x += box.width + 5.0;
    box = [BBHUtil makeStack:array superview:[self contentView] offset:offset];
    
    //[[self contentView] setBackgroundColor:[UIColor redColor]];
    [[self contentView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        //make.left.equalTo(self.mas_left);
        //make.top.equalTo(self.mas_top);
        make.bottom.equalTo([self approvedDateKeyLabel].mas_bottom).with.offset(5.0);
        //make.right.mas_equalTo(box.width + offset.x + 5.0);
    }];
    
    [super updateConstraints];
}

@end