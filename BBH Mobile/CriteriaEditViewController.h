//
//  CriteriaEditViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 11/22/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTClient.h"
#import "Entities.h"
#import "BBHUtil.h"
#import "CriteriaViewController.h"
#import "CriteriaEditView.h"
#import "UIViewController+BBHVIewController.h"

#ifndef CriteriaEditViewController_h
#define CriteriaEditViewController_h

@interface CriteriaEditViewController : CriteriaViewController<BBHEditView>

@property CriteriaEditView* editController;
@property UIBarButtonItem* addBtn;

@end

#endif /* CriteriaEditViewController_h */
