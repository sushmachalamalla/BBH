//
//  RunViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 9/29/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#ifndef BBH_Mobile_RunViewController_h
#define BBH_Mobile_RunViewController_h

#import "UIKit/uikit.h"
#import "Entities.h"
#import "RunSummaryCell.h"
#import "RESTClient.h"
#import "RunDetailViewController.h"

@interface RunSummaryViewController: UITableViewController<UITableViewDataSource, UITableViewDelegate, RESTResponseHandler, BBHView>

@property NSMutableArray* content;
@property int pageNumber;
@property int pageSize;
@property int pageCount;
@property (atomic) BOOL loadInProgress;
@property NSString* actionHREF;
-(NSString*) nextFetchURL;

@end

#endif
