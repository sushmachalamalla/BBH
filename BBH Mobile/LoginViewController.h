//
//  ViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 9/9/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTClient.h"
#import "NavigationViewController.h"
#import "Masonry/Masonry.h"

@interface LoginViewController : UIViewController<RESTResponseHandler>

@property NavigationViewController* runViewController;
@property (weak, nonatomic) IBOutlet UITextField *userTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
- (IBAction)loginTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

- (IBAction)unwindToLoginScreen:(UIStoryboardSegue*)sender;

@end

