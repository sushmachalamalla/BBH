//
//  TimeCardEditViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 11/24/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entities.h"
#import "BBHUtil.h"
#import "RESTClient.h"
#import "TimeCardViewController.h"
#import "TimeCardEditView.h"
#import "RunDetailEditViewController.h"
#import "UIViewController+BBHVIewController.h"

#ifndef TimeCardEditViewController_h
#define TimeCardEditViewController_h

@interface TimeCardEditViewController : TimeCardViewController<BBHEditView>

@property TimeCardEditView* editController;
@property UIBarButtonItem* addBtn;

@end

#endif /* TimeCardEditViewController_h */
