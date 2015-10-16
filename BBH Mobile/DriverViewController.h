//
//  DriverViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/9/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTClient.h"
#import "Entities.h"

#ifndef BBH_Mobile_DriverViewController_h
#define BBH_Mobile_DriverViewController_h

@interface RespondedDriverDelegate : NSObject<RESTResponseHandler, UITableViewDataSource, UITableViewDelegate>

-(void) fetchData;
-(instancetype) initWithCB: (void(^)(void))cb entity:(Run*) runEntity;

@property (copy) void(^cb)(void);
@property Run* runEntity;
@property NSMutableArray* content;

@end

@interface AcceptedDriverDelegate : NSObject<RESTResponseHandler, UITableViewDataSource, UITableViewDelegate>

-(void) fetchData;
-(instancetype) initWithCB: (void(^)(void))cb entity:(Run*) runEntity;

@property (copy) void(^cb)(void);
@property Run* runEntity;
@property NSMutableArray* content;

@end

@interface DriverViewController : UIViewController

@property Run* runEntity;
@property RespondedDriverDelegate* respondedDriverDelegate;
@property AcceptedDriverDelegate* acceptedDriverDelegate;

@property (weak, nonatomic) IBOutlet UITableView *respondedTableView;

@property (weak, nonatomic) IBOutlet UITableView *acceptedTableView;

@end

#endif
