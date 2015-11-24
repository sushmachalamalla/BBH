//
//  RequirementsViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/7/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CriteriaViewController.h"

@implementation CriteriaViewController

@synthesize isUIDone;

-(instancetype)init {
    
    self = [super init];
    
    if(self) {
        
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Equipment/Skill" image:nil tag:40];
        [self setTabBarItem:tabBarItem];
        
        [self setEndorsementContent:[NSMutableArray array]];
        [self setSkillContent:[NSMutableArray array]];
        [self setEquipmentContent:[NSMutableArray array]];
    }
    
    return self;
}

-(void)loadView {
    
    [self setView:[UIView new]];
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

-(void)viewDidLoad {
    
    NSLog(@">> VIEW DID LOAD");
    [super viewDidLoad];
    
    [self makeUI];
    [self fetchData];
}

-(void)updateViewConstraints {
    
    [[self endorsementTableView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self view].mas_top).with.offset(5.0);
        make.left.equalTo([self view].mas_left);
        make.right.equalTo([self view].mas_right);
        make.height.equalTo([self view]).with.multipliedBy(0.30);
    }];
    
    [[self skillTableView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self endorsementTableView].mas_bottom).with.offset(5.0);
        make.left.equalTo([self view].mas_left);
        make.right.equalTo([self view].mas_right);
        make.height.equalTo([self view]).with.multipliedBy(0.30);
    }];
    
    [[self equipmentTableView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self skillTableView].mas_bottom).with.offset(5.0);
        make.left.equalTo([self view].mas_left);
        make.right.equalTo([self view].mas_right);
        make.height.equalTo([self view]).with.multipliedBy(0.30);
    }];
    
    [super updateViewConstraints];
}

-(void)makeUI {
    
    /*SkillViewDelegate* skillDelegate = [[SkillViewDelegate alloc] init];
    
    [skillDelegate setRunEntity:[self runEntity]];
    [self setSkillDelegate:skillDelegate];*/
    
    [self setEndorsementTableView:[[UITableView alloc] init]];
    [self setEquipmentTableView:[[UITableView alloc] init]];
    [self setSkillTableView:[[UITableView alloc] init]];
    
    if([[self endorsementTableView] respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        
        [[self endorsementTableView] setCellLayoutMarginsFollowReadableWidth:NO];
        [[self equipmentTableView] setCellLayoutMarginsFollowReadableWidth:NO];
        [[self skillTableView] setCellLayoutMarginsFollowReadableWidth:NO];
    }
    
    [[self endorsementTableView] setTag:CriteriaTableEndorsement];
    [[self endorsementTableView] setDelegate:self];
    [[self endorsementTableView] setDataSource:self];
    
    [[self skillTableView] setTag:CriteriaTableSkill];
    [[self skillTableView] setDelegate:self];
    [[self skillTableView] setDataSource:self];
    
    [[self equipmentTableView] setTag:CriteriaTableEquipment];
    [[self equipmentTableView] setDelegate:self];
    [[self equipmentTableView] setDataSource:self];
    
    [[self view] addSubview:[self endorsementTableView]];
    [[self view] addSubview:[self skillTableView]];
    [[self view] addSubview:[self equipmentTableView]];
    
    [[self view] setNeedsUpdateConstraints];
}

-(void)fetchData {
    
    [[self skillContent] removeAllObjects];
    [[self equipmentContent] removeAllObjects];
    [[self endorsementContent] removeAllObjects];
    
    RESTClient* client = [RESTClient instance];
    
    [client doGETWithURL:[NSString stringWithFormat:@"runs/%d/runSkills",[[self runEntity] runId]] params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@">> SKILL: %@", data);
            
            NSArray* runEquipSkills = [data valueForKey:@"RunEquipmentSkills"];
            [runEquipSkills enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [[self skillContent] addObject:[[RunEquipmentSkill alloc] initWithDict:obj]];
            }];
            
            [[self skillTableView] reloadData];
        }
    }];
    
    [client doGETWithURL:[NSString stringWithFormat:@"runs/%d/runEndorsements",[[self runEntity] runId]] params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@">> END: %@", data);
            
            NSArray* runEquipSkills = [data valueForKey:@"RunEquipmentSkills"];
            [runEquipSkills enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [[self endorsementContent] addObject:[[RunEquipmentSkill alloc] initWithDict:obj]];
            }];
            
            //NSLog(@">> END DATA: %d", [[self content] count]);
            [[self endorsementTableView] reloadData];
        }
    }];
    
    [client doGETWithURL:[NSString stringWithFormat:@"runs/%d/runEquipments",[[self runEntity] runId]] params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@">> EQUIP: %@", data);
            
            NSArray* runEquipSkills = [data valueForKey:@"RunEquipmentSkills"];
            [runEquipSkills enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [[self equipmentContent] addObject:[[RunEquipmentSkill alloc] initWithDict:obj]];
            }];
            
            [[self equipmentTableView] reloadData];
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = nil;
    
    if([tableView tag] == CriteriaTableEndorsement) {
        
        EndorsementCell *endCell = [tableView dequeueReusableCellWithIdentifier:@"endorsementDataCell"];
        
        if(!endCell) {
            endCell = [[EndorsementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"endorsementDataCell"];
        }
        
        RunEquipmentSkill* endorsement = [[self endorsementContent] objectAtIndex:[indexPath row]];
        [[endCell endorsementLabel] setText: [[endorsement equipmentSkill] equipmentSkillName]];
        
        cell = endCell;
        
    } else if([tableView tag] == CriteriaTableEquipment) {
        
        EquipmentCell* equipCell = [tableView dequeueReusableCellWithIdentifier:@"equipmentDataCell"];
        
        if(!equipCell) {
            equipCell = [[EquipmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"equipmentDataCell"];
        }
        
        RunEquipmentSkill* equipment = [[self equipmentContent] objectAtIndex:[indexPath row]];
        [[equipCell equipmentLabel] setText: [[equipment equipmentSkill] equipmentSkillName]];
        [[equipCell yearSlotLabel] setText: [[equipment experienceSlot] experienceSlotName]];
        
        cell = equipCell;
        
    } else if([tableView tag] == CriteriaTableSkill) {
        
        SkillCell* skillCell = [tableView dequeueReusableCellWithIdentifier:@"skillDataCell"];
        
        if(!skillCell) {
            skillCell = [[SkillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"skillDataCell"];
        }
        
        RunEquipmentSkill* skill = [[self skillContent] objectAtIndex:[indexPath row]];
        [[skillCell skillLabel] setText: [[skill equipmentSkill] equipmentSkillName]];
        [[skillCell yearSlotLabel] setText: [[skill experienceSlot] experienceSlotName]];
        
        cell = skillCell;
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewCell* cell = nil;
    
    if([tableView tag] == CriteriaTableEndorsement) {
        
        EndorsementCell *endCell = [tableView dequeueReusableCellWithIdentifier:@"endorsementDataCell"];
        
        if(!endCell) {
            endCell = [[EndorsementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"endorsementDataCell"];
        }
        
        [[endCell endorsementLabel] setText: @"Endorsement"];
        [[endCell endorsementLabel] setTextColor:[BBHUtil headerTextColor]];
        
        cell = endCell;
        
    } else if([tableView tag] == CriteriaTableEquipment) {
        
        EquipmentCell* equipCell = [tableView dequeueReusableCellWithIdentifier:@"equipmentDataCell"];
        
        if(!equipCell) {
            equipCell = [[EquipmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"equipmentDataCell"];
        }
        
        [[equipCell equipmentLabel] setText: @"Equipment"];
        [[equipCell yearSlotLabel] setText: @"Year Slot"];
        
        [[equipCell equipmentLabel] setTextColor:[BBHUtil headerTextColor]];
        [[equipCell yearSlotLabel] setTextColor:[BBHUtil headerTextColor]];
        
        cell = equipCell;
        
    } else if([tableView tag] == CriteriaTableSkill) {
        
        SkillCell* skillCell = [tableView dequeueReusableCellWithIdentifier:@"skillDataCell"];
        
        if(!skillCell) {
            skillCell = [[SkillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"skillDataCell"];
        }
        
        [[skillCell skillLabel] setText: @"Skill"];
        [[skillCell yearSlotLabel] setText: @"Year Slot"];
        
        [[skillCell skillLabel] setTextColor:[BBHUtil headerTextColor]];
        [[skillCell yearSlotLabel] setTextColor:[BBHUtil headerTextColor]];
        
        cell = skillCell;
    }
    
    [[cell contentView] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [[cell contentView] setOpaque:YES];
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

-(NSArray*)contentForCriteriaTable: (CriteriaTable)tag {
    
    NSArray* content = nil;
    
    if(tag == CriteriaTableEndorsement) {
        
        content = [self endorsementContent];
        
    } else if(tag == CriteriaTableEquipment) {
        
        content = [self equipmentContent];
        
    } else if(tag == CriteriaTableSkill) {
        
        content = [self skillContent];
    }
    
    return content;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self contentForCriteriaTable:[tableView tag]] count];
}

@end
