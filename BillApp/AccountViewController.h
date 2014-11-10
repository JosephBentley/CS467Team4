//
//  AccountViewController.h
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *groupName;
- (IBAction)addGroup:(id)sender;
- (IBAction)saveButton:(id)sender;
@property (strong, nonatomic) NSString *enableReport;
@property (weak, nonatomic) NSString* first;
@property (weak, nonatomic) NSString* last;
- (IBAction)menu:(id)sender;
- (IBAction)createGroup:(id)sender;
@property (weak, nonatomic) NSString* email;
@end
