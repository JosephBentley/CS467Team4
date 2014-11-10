//
//  LoginViewController.h
//  BillApp
//
//  Created by X Code User on 10/3/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UILabel *invalidText;
- (IBAction)loginPressed:(id)sender;

@end
