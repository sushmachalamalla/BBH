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

#ifndef BBH_Mobile_RequirementsViewController_h
#define BBH_Mobile_RequirementsViewController_h

@interface CriteriaViewController : UIViewController

-(void) reloadTableView: (NSString*)tableName;

@property Run* runEntity;

@property (weak, nonatomic) IBOutlet UITableView *endorsementTableView;
@property (weak, nonatomic) IBOutlet UITableView *skillTableView;
@property (weak, nonatomic) IBOutlet UITableView *equipmentTableView;

@end

@interface EndorsementViewDelegate : NSObject<RESTResponseHandler, UITableViewDataSource, UITableViewDelegate>

-(void) fetchData;
-(instancetype) initWithCB: (void(^)(void))cb entity:(Run*) runEntity;

@property (copy) void(^cb)(void);
@property Run* runEntity;
@property NSMutableArray* content;

@end

@interface SkillViewDelegate : NSObject<RESTResponseHandler, UITableViewDataSource, UITableViewDelegate>

-(void) fetchData;
-(instancetype) initWithCB: (void(^)(void))cb entity:(Run*) runEntity;

@property (copy) void(^cb)(void);
@property Run* runEntity;
@property NSMutableArray* content;

@end

@interface EquipmentViewDelegate : NSObject<RESTResponseHandler, UITableViewDataSource, UITableViewDelegate>

-(void) fetchData;
-(instancetype) initWithCB: (void(^)(void))cb entity:(Run*) runEntity;

@property (copy) void(^cb)(void);
@property Run* runEntity;
@property NSMutableArray* content;

@end

#endif
