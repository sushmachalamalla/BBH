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

/*-(void)updateConstraints {
    
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
}*/

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