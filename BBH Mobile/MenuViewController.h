//
//  MenuListViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 9/25/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "UIKit/uikit.h"
#import "RESTClient.h"
#import "RunSummaryViewController.h"
#import "InvoiceViewController.h"

#ifndef BBH_Mobile_MenuListViewController_h
#define BBH_Mobile_MenuListViewController_h

@interface MenuViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, RESTResponseHandler>

@property NSMutableArray* content;
@property NSString* lastAction;

@end

#endif
