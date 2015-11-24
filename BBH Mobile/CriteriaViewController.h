//
//  RequirementsViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/7/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "UIKit/uikit.h"
#import "RESTClient.h"
#import "Entities.h"
#import "CriteriaCell.h"

#ifndef BBH_Mobile_RequirementsViewController_h
#define BBH_Mobile_RequirementsViewController_h

typedef  NS_ENUM(NSInteger, CriteriaTable) {
    CriteriaTableSkill, CriteriaTableEquipment, CriteriaTableEndorsement, CriteriaTableNone
};

@interface CriteriaViewController : UIViewController<BBHView, UITableViewDataSource, UITableViewDelegate>

@property Run* runEntity;

@property (strong, nonatomic) UITableView *endorsementTableView;
@property (strong, nonatomic) UITableView *skillTableView;
@property (strong, nonatomic) UITableView *equipmentTableView;

@property NSMutableArray* skillContent;
@property NSMutableArray* equipmentContent;
@property NSMutableArray* endorsementContent;

-(NSArray*)contentForCriteriaTable: (CriteriaTable)tag;

@end

/*@interface SkillViewDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>

@property Run* runEntity;

@property NSMutableArray* skillContent;
@property NSMutableArray* equipmentContent;
@property NSMutableArray* endorsementContent;

-(NSArray*)contentForCriteriaTable: (CriteriaTable)tag;

@end*/

#endif
