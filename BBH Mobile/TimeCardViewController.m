//
//  TimeCardViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/8/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeCardViewController.h"
#import "RunDetailViewController.h"

@implementation TimeCardViewController

@synthesize isUIDone;

-(instancetype)init {
    
    self = [super init];
    
    if(self) {
        
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Time Card" image:nil tag:50];
        [self setTabBarItem:tabBarItem];
    }
    
    return self;
}

-(void)viewDidLoad {
    
    [self makeUI];
    [self fetchData];
}

-(void)fetchData {
    
    [self setContent:[NSMutableArray array]];
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[NSString stringWithFormat:@"runs/%d/timeCards",[[self runEntity] runId]] absolute:NO params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@"TC DATA: %@", data);
            
            NSArray* timeCards = [data valueForKey:@"TimeCards"];
            [timeCards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [[self content] addObject:[[TimeCard alloc] initWithDict:obj]];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[self tableView] reloadData];
            });
        }
    }];
}

-(void)updateViewConstraints {
    
    //NSLog(@"+++++++++++++ UPDATE CONSTRAINTS ++++++++++++++");
    
    [[self tcTableView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self view].mas_top).with.offset(20.0);
        make.left.equalTo([self view].mas_left);
        make.right.equalTo([self view].mas_right);
        make.bottom.equalTo([self view].mas_bottom);
    }];
    
    [super updateViewConstraints];
}

-(void) makeUI {
    
    [self setTcTableView:[[UITableView alloc] init]];
    [[self tcTableView] setDataSource:self];
    [[self tcTableView] setDelegate:self];
    
    if([[self tcTableView] respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        
        [[self tcTableView] setCellLayoutMarginsFollowReadableWidth:NO];
    }
    
    [[self view] addSubview:[self tcTableView]];
    [[self view] setNeedsUpdateConstraints];
}

-(void) populate {
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        [[self tcTableView] reloadData];
    });
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeCardViewCell* cell = (TimeCardViewCell*)[tableView dequeueReusableCellWithIdentifier:@"tcDataCell"];
    
    if(!cell) {
        
        cell = [[TimeCardViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tcDataCell"];
    }
    
    TimeCard* tc = [[self content] objectAtIndex:[indexPath row]];
    
    NSString* fullName = [[tc driver] fullName];
    NSString* status = [[tc timeCardStatus] timeCardStatusName];
    NSString* approvalBy = [BBHUtil isNull:[tc approvalBy]] ? @"N/A" : [[tc approvalBy] fullName];
    NSString* approvalDate = [BBHUtil isNull:[tc approvalDate]] ? @"N/A" : [[BBHUtil dateFormat] stringFromDate:[tc approvalDate]];
    
    [[cell nameLabel] setText:fullName];
    [[cell statusLabel] setText:status];
    [[cell approvedByLabel] setText:approvalBy];
    [[cell approvedDateLabel] setText:approvalDate];
    
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self content] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView*)view;
    [[header textLabel] setText:@"Time Card"];
    [[header textLabel] setTextColor:[BBHUtil headerTextColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static dispatch_once_t onceToken;
    static TimeCardViewCell* cell = nil;
    
    dispatch_once(&onceToken, ^{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"tcDataCell"];
    });
    
    [cell updateConstraintsIfNeeded];
    [cell layoutIfNeeded];
    
    CGSize size = [[cell contentView] systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
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