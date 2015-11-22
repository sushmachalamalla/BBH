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

@synthesize isUIDone;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        [self makeUI];
    }
    
    return self;
}

-(void)populate {
    //
}

-(void) makeUI {
    
    if (![self companyKeyLabel]) {
        
        [self setCompanyKeyLabel:[BBHUtil makeLabelWithText:@"Company:"]];
        [self setRunTitleKeyLabel:[BBHUtil makeLabelWithText:@"Run Title:"]];
        [self setEstPayKeyLabel:[BBHUtil makeLabelWithText: @"Est Pay:"]];
        [self setDriverTypeKeyLabel:[BBHUtil makeLabelWithText:@"Driver Type:"]];
        [self setDriverClassKeyLabel:[BBHUtil makeLabelWithText:@"Driver Class:"]];
        
        [self setCompanyLabel:[BBHUtil makeLabelWithText:@"-"]];
        [self setRunTitleLabel:[BBHUtil makeLabelWithText:@"-"]];
        [self setEstPayLabel:[BBHUtil makeLabelWithText: @"-"]];
        [self setDriverTypeLabel:[BBHUtil makeLabelWithText:@"-"]];
        [self setDriverClassLabel:[BBHUtil makeLabelWithText:@"-"]];
        
        [self setPickupAddrView:[[UIView alloc] init]];
        
        [self setPickupKeyLabel:[BBHUtil makeLabelWithText:@"Pickup"]];
        [self setPickupDateLabel:[BBHUtil makeLabelWithText:@"-"]];
        [self setPickupLocationLabel:[BBHUtil makeLabelWithText:@"-"]];
        
        [[self pickupAddrView] addSubview:[self pickupKeyLabel]];
        [[self pickupAddrView] addSubview:[self pickupDateLabel]];
        [[self pickupAddrView] addSubview:[self pickupLocationLabel]];
        
        [self setDropAddrView:[[UIView alloc] init]];
        
        [self setDropKeyLabel:[BBHUtil makeLabelWithText:@"Drop"]];
        [self setDropDateLabel:[BBHUtil makeLabelWithText:@"-"]];
        [self setDropLocationLabel:[BBHUtil makeLabelWithText:@"-"]];
        
        [[self dropAddrView] addSubview:[self dropKeyLabel]];
        [[self dropAddrView] addSubview:[self dropDateLabel]];
        [[self dropAddrView] addSubview:[self dropLocationLabel]];
        
        [[self contentView] addSubview:[self companyKeyLabel]];
        [[self contentView] addSubview:[self companyLabel]];
        [[self contentView] addSubview:[self runTitleKeyLabel]];
        [[self contentView] addSubview:[self runTitleLabel]];
        [[self contentView] addSubview:[self estPayKeyLabel]];
        [[self contentView] addSubview:[self estPayLabel]];
        [[self contentView] addSubview:[self driverTypeKeyLabel]];
        [[self contentView] addSubview:[self driverTypeLabel]];
        [[self contentView] addSubview:[self driverClassKeyLabel]];
        [[self contentView] addSubview:[self driverClassLabel]];
        
        [[self contentView] addSubview:[self pickupAddrView]];
        [[self contentView] addSubview:[self dropAddrView]];
    }
}

-(void)updateConstraints {
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> UPDATE");
    
    //UIFont* textFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    UIView* view = [self contentView];
    
    __block CGPoint offset = CGPointMake(5.0, 5.0);
    
    __block NSArray* array = [NSArray arrayWithObjects: [self companyKeyLabel], [self runTitleKeyLabel], [self estPayKeyLabel], [self driverTypeKeyLabel], [self driverClassKeyLabel], nil];
    
    //__block CGPoint bottomRight = [BBHUtil makeColumn: array withOrig:orig superview:view];
    __block CGSize box = CGSizeMake(-1.0, -1.0);
    
    box = [BBHUtil makeStack:array superview:view offset:offset];
    
    offset.x += box.width;
    array = [NSArray arrayWithObjects: [self companyLabel], [self runTitleLabel], [self estPayLabel], [self driverTypeLabel], [self driverClassLabel], nil];
    
    box = [BBHUtil makeStack:array superview:view offset:offset];
    
    [[self pickupAddrView] setOpaque:YES];
    [[self pickupAddrView] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [[self pickupAddrView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self driverClassKeyLabel].mas_bottom).with.offset(10.0);
        make.left.equalTo(view.mas_left).with.offset(5.0);
        //make.width.equalTo(view.mas_width).multipliedBy(0.45);
    }];
    
    offset = CGPointMake(5.0, 5.0);
    array = [NSArray arrayWithObjects:[self pickupKeyLabel], [self pickupLocationLabel],[self pickupDateLabel],nil];
    
    box = [BBHUtil makeStack:array superview:[self pickupAddrView] offset:offset];
    
    [[self pickupAddrView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo([self pickupDateLabel].mas_bottom).with.offset(5.0);
        make.right.equalTo(view.mas_left).with.offset(5.0 + box.width + offset.x);
    }];
    
    [[self dropAddrView] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [[self dropAddrView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self pickupAddrView].mas_top);
        make.left.equalTo([self pickupAddrView].mas_right).with.offset(5.0);
    }];
    
    array = [NSArray arrayWithObjects:[self dropKeyLabel], [self dropLocationLabel],[self dropDateLabel],nil];
    box = [BBHUtil makeStack:array superview:[self dropAddrView] offset:offset];
    
    [[self dropAddrView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo([self pickupAddrView].mas_right).with.offset(5.0 + box.width + offset.x);
        make.bottom.equalTo([self dropDateLabel].mas_bottom).with.offset(5.0);
    }];
    
    [[self contentView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self).with.offset(5.0);
        //make.top.equalTo(self.mas_top);
    }];
    
    [super updateConstraints];
}

@end