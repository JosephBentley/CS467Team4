//
//  LoginViewController.h
//  BillApp
//
//  Created by X Code User on 10/3/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVUserService.h"

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UILabel *invalidText;
@property (strong, nonatomic) GVUserService* userService;
- (IBAction)loginPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccButton;

@end
