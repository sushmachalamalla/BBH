//
//  RequirementsViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/7/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CriteriaViewController.h"

@interface CriteriaViewController ()

@property EndorsementViewDelegate* endorsementDelegate;
@property SkillViewDelegate* skillDelegate;
@property EquipmentViewDelegate* equipmentDelegate;

@end

@implementation CriteriaViewController

-(void)reloadTableView:(NSString *)tableName {
    
    UITableView* tableView = nil;
    if([tableName isEqualToString:@"endorsement"]) {
        
        tableView = [self endorsementTableView];
        
    } else if([tableName isEqualToString:@"skill"]) {
        
        tableView = [self skillTableView];
        
    } else if([tableName isEqualToString:@"equipment"]) {
        
        tableView = [self equipmentTableView];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [tableView reloadData];
    });
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Equipment/Skill" image:nil tag:40];
        [self setTabBarItem:tabBarItem];
    }
    
    return self;
}

-(void)viewDidLoad {
    
    NSLog(@">> VIEW DID LOAD");
    
    EndorsementViewDelegate* endorsementDelegate = [[EndorsementViewDelegate alloc] initWithCB:^{
        [self reloadTableView:@"endorsement"];
    } entity:[self runEntity]];
    
    SkillViewDelegate* skillDelegate = [[SkillViewDelegate alloc] initWithCB:^{
        [self reloadTableView:@"skill"];
    } entity:[self runEntity]];
    
    EquipmentViewDelegate* equipmentDelegate = [[EquipmentViewDelegate alloc] initWithCB:^{
        [self reloadTableView:@"equipment"];
    } entity:[self runEntity]];
    
    [self setEndorsementDelegate:endorsementDelegate];
    [self setSkillDelegate:skillDelegate];
    [self setEquipmentDelegate:equipmentDelegate];
    
    [[self endorsementTableView] setDelegate:endorsementDelegate];
    [[self endorsementTableView] setDataSource:endorsementDelegate];
    
    [[self skillTableView] setDelegate:skillDelegate];
    [[self skillTableView] setDataSource:skillDelegate];
    
    [[self equipmentTableView] setDelegate:equipmentDelegate];
    [[self equipmentTableView] setDataSource:equipmentDelegate];
    
    [endorsementDelegate fetchData];
    [skillDelegate fetchData];
    [equipmentDelegate fetchData];
}

@end

@implementation EndorsementViewDelegate

-(instancetype)initWithCB:(void(^)(void))cb entity:(Run *)runEntity {
    
    self = [super init];
    
    if(self) {
        
        [self setCb:cb];
        [self setRunEntity:runEntity];
        [self setContent:[NSMutableArray array]];
    }
    
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"endDataCell" forIndexPath:indexPath];
    
    UILabel* endorsementLabel = (UILabel*)[cell viewWithTag:100];
    
    if(!endorsementLabel) {
        
        NSLog(@">> NOT FOUND");
        
        endorsementLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 11, 400.0, 21.0)];
        
        [endorsementLabel setTextAlignment:NSTextAlignmentLeft];
        
        [endorsementLabel setTextColor:[UIColor grayColor]];
        
        [endorsementLabel setTag:100];
        
        [[cell contentView] addSubview:endorsementLabel];
    }
    
    RunEquipmentSkill* skill = [[self content] objectAtIndex:[indexPath row]];
    [endorsementLabel setText:[[skill equipmentSkill] equipmentSkillName]];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 32.0)];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 400.0, 21.0)];
    [label setTextColor:[BBHUtil headerTextColor]];
    [label setText:@"Endorsements"];
    
    //[[tableView dequeueReusableCellWithIdentifier:@"endHeaderCell"] viewWithTag:100]
    
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [view addSubview:label];
    [view setOpaque:YES];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self content] count];
}

-(void)fetchData {
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[NSString stringWithFormat:@"runs/%d/runEndorsements",[[self runEntity] runId]] data:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@">> END: %@", data);
            
            NSArray* runEquipSkills = [data valueForKey:@"RunEquipmentSkills"];
            [runEquipSkills enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [[self content] addObject:[[RunEquipmentSkill alloc] initWithDict:obj]];
            }];
            
            //NSLog(@">> END DATA: %d", [[self content] count]);
            [self cb]();
        }
    }];
}

-(void)success:(NSDictionary *)data {
    
    
}

-(void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    //
}

-(void)progress:(NSNumber *)percent {
    //
}

@end

@implementation SkillViewDelegate

-(instancetype)initWithCB:(void(^)(void))cb entity:(Run *)runEntity {
    
    self = [super init];
    
    if(self) {
        
        [self setCb:cb];
        [self setRunEntity:runEntity];
        [self setContent:[NSMutableArray array]];
    }
    
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"skillDataCell" forIndexPath:indexPath];
        
    UILabel* skillLabel = (UILabel*)[cell viewWithTag:100];
    UILabel* expLabel = (UILabel*)[cell viewWithTag:101];
    
    if(!skillLabel) {
        
        NSLog(@">> NOT FOUND");
        
        skillLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 11, 250.0, 21.0)];
        expLabel = [[UILabel alloc] initWithFrame:CGRectMake(310, 11, 143.0, 21.0)];
        
        [skillLabel setTextAlignment:NSTextAlignmentLeft];
        [expLabel setTextAlignment:NSTextAlignmentRight];
        
        [skillLabel setTextColor:[UIColor grayColor]];
        [expLabel setTextColor:[UIColor grayColor]];
        
        [skillLabel setTag:100];
        [expLabel setTag:101];
        
        [[cell contentView] addSubview:skillLabel];
        [[cell contentView] addSubview:expLabel];
    }
    
    RunEquipmentSkill* skill = [[self content] objectAtIndex:[indexPath row]];
    [skillLabel setText:[[skill equipmentSkill] equipmentSkillName]];
    [expLabel setText:[[skill experienceSlot] experienceSlotName]];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 32.0)];
    UILabel* skillLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 250.0, 21.0)];
    UILabel* expLabel = [[UILabel alloc] initWithFrame:CGRectMake(310, 5, 143.0, 21.0)];
    
    [skillLabel setTextColor:[BBHUtil headerTextColor]];
    [skillLabel setText:@"Skill"];
    
    [expLabel setTextColor:[BBHUtil headerTextColor]];
    [expLabel setText:@"Year Slot"];
    
    [expLabel setTextAlignment:NSTextAlignmentRight];
    
    //[[tableView dequeueReusableCellWithIdentifier:@"endHeaderCell"] viewWithTag:100]
    
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [view addSubview:skillLabel];
    [view addSubview:expLabel];
    [view setOpaque:YES];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self content] count];
}

-(void)fetchData {
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[NSString stringWithFormat:@"runs/%d/runSkills",[[self runEntity] runId]] data:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@">> SKILL: %@", data);
            
            NSArray* runEquipSkills = [data valueForKey:@"RunEquipmentSkills"];
            [runEquipSkills enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [[self content] addObject:[[RunEquipmentSkill alloc] initWithDict:obj]];
            }];
            
            [self cb]();
        }
    }];
}

-(void)success:(NSDictionary *)data {
    
    
}

-(void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    //
}

-(void)progress:(NSNumber *)percent {
    //
}

@end

@implementation EquipmentViewDelegate

-(instancetype)initWithCB:(void(^)(void))cb entity:(Run *)runEntity {
    
    self = [super init];
    
    if(self) {
        
        [self setCb:cb];
        [self setRunEntity:runEntity];
        [self setContent:[NSMutableArray array]];
    }
    
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"eqDataCell" forIndexPath:indexPath];
        
    UILabel* skillLabel = (UILabel*)[cell viewWithTag:100];
    UILabel* expLabel = (UILabel*)[cell viewWithTag:101];
    
    if(!skillLabel) {
        
        NSLog(@">> NOT FOUND");
        
        skillLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 11, 250.0, 21.0)];
        expLabel = [[UILabel alloc] initWithFrame:CGRectMake(310, 11, 143.0, 21.0)];
        
        [skillLabel setTextAlignment:NSTextAlignmentLeft];
        [expLabel setTextAlignment:NSTextAlignmentRight];
        
        [skillLabel setTextColor:[UIColor grayColor]];
        [expLabel setTextColor:[UIColor grayColor]];
        
        [skillLabel setTag:100];
        [expLabel setTag:101];
        
        [[cell contentView] addSubview:skillLabel];
        [[cell contentView] addSubview:expLabel];
    }
    
    RunEquipmentSkill* skill = [[self content] objectAtIndex:[indexPath row]];
    [skillLabel setText:[[skill equipmentSkill] equipmentSkillName]];
    [expLabel setText:[[skill experienceSlot] experienceSlotName]];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 32.0)];
    UILabel* skillLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 250.0, 21.0)];
    UILabel* expLabel = [[UILabel alloc] initWithFrame:CGRectMake(310, 5, 143.0, 21.0)];
    
    [skillLabel setTextColor:[BBHUtil headerTextColor]];
    [skillLabel setText:@"Equipment"];
    
    [expLabel setTextColor:[BBHUtil headerTextColor]];
    [expLabel setText:@"Year Slot"];
    
    [expLabel setTextAlignment:NSTextAlignmentRight];
    
    //[[tableView dequeueReusableCellWithIdentifier:@"endHeaderCell"] viewWithTag:100]
    
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [view addSubview:skillLabel];
    [view addSubview:expLabel];
    [view setOpaque:YES];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self content] count];
}

-(void)fetchData {
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[NSString stringWithFormat:@"runs/%d/runEquipments",[[self runEntity] runId]] data:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@">> EQUIP: %@", data);
            
            NSArray* runEquipSkills = [data valueForKey:@"RunEquipmentSkills"];
            [runEquipSkills enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [[self content] addObject:[[RunEquipmentSkill alloc] initWithDict:obj]];
            }];
            
            [self cb]();
        }
    }];
}

-(void)success:(NSDictionary *)data {
    
    
}

-(void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    //
}

-(void)progress:(NSNumber *)percent {
    //
}

@end