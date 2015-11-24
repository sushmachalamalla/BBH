//
//  CriteriaEditView.m
//  BBH Mobile
//
//  Created by Mac-Mini on 11/22/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CriteriaEditView.h"

@implementation CriteriaEditView

@synthesize isClean;
@synthesize isUIDone;
@synthesize mode;

- (instancetype)init {
    
    NSLog(@"++++++++ INIT");
    self = [super init];
    
    if(self) {
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
    }
    
    return self;
}

-(void)loadView {
    
    NSLog(@"+++++++++++++++ loadView");
    
    [self setView:[UIView new]];
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [[self view] setOpaque:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([self isUIDone]) {
        [self populate];
    }
    
    if ([self tableType] == CriteriaTableEndorsement) {
        [[self yearSlotLabel] setHidden:YES];
        [[self yearSlotPicker] setHidden:YES];
    } else {
        [[self yearSlotLabel] setHidden:NO];
        [[self yearSlotPicker] setHidden:NO];
    }
}

-(void)viewDidLoad {
    
    [[self navigationItem] setTitle:([self mode] == EntityModeAdd ? @"Criterion Add" : @"Criterion Edit")];
    
    UIBarButtonItem* saveBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveInfo)];
    
    NSMutableArray* btnList = [NSMutableArray arrayWithArray:[[self navigationItem] leftBarButtonItems]];
    
    [btnList addObject:saveBtn];
    
    NSLog(@">>> BAR BTN ITEMS: %lu", (unsigned long)[btnList count]);
    
    [[self navigationItem] setLeftItemsSupplementBackButton:YES];
    [[self navigationItem] setLeftBarButtonItems:btnList];
    NSLog(@">>> BAR BTN ITEMS: %lu", (unsigned long)[[[self navigationItem] leftBarButtonItems] count]);
    
    [self makeUI];
    [self populate];
    [[self view] setNeedsUpdateConstraints];
}

-(void) updateViewConstraints {
    
    NSLog(@">>>>>>>>>>>> UPDATE CONSTRAINTS");
    
    [[self contentView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo([self view]).with.insets(UIEdgeInsetsMake(0.0, 0.0, 0.0, 10.0));
    }];
    
    NSArray* array = [[NSArray alloc] initWithObjects:[self skillLabel], [self skillPicker], [self yearSlotLabel], [self yearSlotPicker], nil];
    
    [BBHUtil makeStackEdit:array superview:[self contentView] offset:CGPointMake(5.0, [BBHUtil statusBarHeight] + 5.0)];
    
    [super updateViewConstraints];
}

-(void)populate {
    
    RunEquipmentSkill* runSkill = [self skillEntity];
    
    RESTClient* client = [RESTClient instance];
    
    __block EquipmentSkill* selSkill = nil;
    __block ExperienceSlot* selExp = nil;
    
    NSString* url = ([self tableType] == CriteriaTableEndorsement) ? @"endorsements" : (([self tableType] == CriteriaTableEquipment) ? @"equipments" : @"skills");
    
    int skillId = [self mode] == EntityModeEdit ? [[runSkill equipmentSkill] equipmentSkillId] : -1;
    
    [[[self skillDelegate] content] removeAllObjects];
    [[[self experienceDelegate] content] removeAllObjects];
    
    [client doGETWithURL:url params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            //NSLog([NSString stringWithFormat:@"SUCCESS >> %@", data]);
            NSArray* types = [data valueForKey:@"EquipmentSkills"];
            
            [types enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                EquipmentSkill* skill = [[EquipmentSkill alloc] initWithDict:obj];
                [[[self skillDelegate] content] addObject:skill];
                
                if ([skill equipmentSkillId] == skillId) {
                    selSkill = skill;
                }
            }];
            
            [[self skillPicker] reloadAllComponents];
            if(selSkill) {
                [[self skillPicker] selectRow:[[[self skillDelegate] content] indexOfObject:selSkill] inComponent:0 animated:YES];
            } else {
                [[self skillPicker] selectRow:0 inComponent:0 animated:YES];
            }
            
        } else {
            
            NSLog(@">> An error occured fetching equipment skills");
        }
    }];
    
    int expId = [self mode] == EntityModeEdit ? [[runSkill experienceSlot] experienceSlotId] : -1;
    
    [client doGETWithURL:@"experienceSlots" params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            //NSLog([NSString stringWithFormat:@"SUCCESS >> %@", data]);
            NSArray* types = [data valueForKey:@"ExperienceSlots"];
            
            [types enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                ExperienceSlot* exp = [[ExperienceSlot alloc] initWithDict:obj];
                [[[self experienceDelegate] content] addObject:exp];
                
                if ([exp experienceSlotId] == expId) {
                    selExp = exp;
                }
            }];
            
            [[self yearSlotPicker] reloadAllComponents];
            if(selExp) {
                [[self yearSlotPicker] selectRow:[[[self experienceDelegate] content] indexOfObject:selExp] inComponent:0 animated:YES];
            } else {
                [[self yearSlotPicker] selectRow:0 inComponent:0 animated:YES];
            }
            
        } else {
            
            NSLog(@">> An error occured fetching experience slots");
        }
    }];
}

-(void) makeUI {
    
    [self setContentView:[UIView new]];
    
    [self setSkillLabel: [BBHUtil makeLabelWithText: @"Skill"]];
    [self setSkillPicker: [[UIPickerView alloc] init]];
    
    [self setSkillDelegate:[[PickerDelegate alloc] init]];
    [[self skillDelegate] setOnSelect:^{
        //
    }];
    
    [[self skillPicker] setDelegate:[self skillDelegate]];
    
    [[self contentView] addSubview:[self skillLabel]];
    [[self contentView] addSubview:[self skillPicker]];
    
    [self setYearSlotLabel: [BBHUtil makeLabelWithText: @"Year Slot"]];
    [self setYearSlotPicker: [[UIPickerView alloc] init]];
    
    [self setExperienceDelegate:[[PickerDelegate alloc] init]];
    [[self experienceDelegate] setOnSelect:^{
        //
    }];
    
    [[self yearSlotPicker] setDelegate:[self experienceDelegate]];
    
    [[self contentView] addSubview:[self yearSlotLabel]];
    [[self contentView] addSubview:[self yearSlotPicker]];
    
    [[self view] addSubview:[self contentView]];
    [self setIsUIDone:YES];
}

-(void)confirmSave:(void (^)(ConfirmResponse))handler {
    //
}

-(void) saveInfo {
    
    RunEquipmentSkill* runSkill = [[RunEquipmentSkill alloc] init];
    if ([self mode] == EntityModeEdit) {
        runSkill = [runSkill initWithDict:[[self skillEntity] exportToDict]];
    }
    
    id skill = [[[self skillDelegate] content] objectAtIndex:[[self skillPicker] selectedRowInComponent:0]];
    
    id exp = [[[self experienceDelegate] content] objectAtIndex:[[self yearSlotPicker] selectedRowInComponent:0]];
    
    bool skillInput = ![skill isKindOfClass:[BBHNone class]];
    bool expInput = ![exp isKindOfClass:[BBHNone class]];
    
    NSString* fieldName = nil;
    if (!skillInput) {
        
        fieldName = [[self skillLabel] text];
        
    } else if (([self tableType] == CriteriaTableEquipment || [self tableType] == CriteriaTableEquipment) && (!expInput)) {
        
        fieldName = [[self yearSlotLabel] text];
    }
    
    if (fieldName) {
        
        [BBHUtil showValidationAlert:self field:fieldName];
        return;
    }
    
    [runSkill setEquipmentSkill: (EquipmentSkill*) skill];
    [runSkill setExperienceSlot: expInput ? (ExperienceSlot*) exp : nil];
    
    NSError* error = nil;
    NSArray* runSkillList = [[NSArray alloc] initWithObjects:[runSkill exportToDict], nil];
    NSDictionary* runSkillListJSON = [NSDictionary dictionaryWithObjectsAndKeys:runSkillList, @"RunEquipmentSkills", nil];
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:runSkillListJSON options:kNilOptions error:&error];
    
    if(data && !error) {
        
        NSLog(@">> Saving SKILL: %@", runSkillListJSON);
        
        RESTClient* client = [RESTClient instance];
        
        NSString* link = [NSString stringWithFormat:@"runs/%d/runEquipmentSkills", [[self runEntity] runId]];
        
        id handler = ^(RESTResponse response, NSDictionary* dict) {
            
            if(response == RESTResponseSuccess) {
                
                NSLog(@"Saved SKILL: %@", dict);
                [self setSkillEntity: [[self skillEntity] initWithDict:[runSkill exportToDict]]];
                [self setIsClean:YES];
                
            } else {
                
                NSLog(@"Error Saving SKILL: %@", dict);
            }
        };
        
        [client doPUTWithURL:link data:data complete:handler];
        
    } else {
        
        NSLog(@">> ERROR Saving SKILL !!");
    }
}

@end