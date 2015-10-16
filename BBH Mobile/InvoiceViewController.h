//
//  InvoiceViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/10/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTClient.h"
#import "Entities.h"

#ifndef BBH_Mobile_InvoiceViewController_h
#define BBH_Mobile_InvoiceViewController_h

@interface InvoiceViewController : UITableViewController<RESTResponseHandler, UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray* content;
@property BOOL isPaid;

@property int pageNumber;
@property int pageSize;
@property int pageCount;
@property (atomic) BOOL loadInProgress;
@property NSString* actionHREF;
-(NSString*) nextFetchURL;

@end

#endif
