//
//  UIGroupInviteUserViewController.h
//  BillApp
//
//  Created by X Code User on 11/20/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVGroupsService.h"

@interface UIGroupInviteUserViewController : UIViewController //<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic)GVGroupsService* groupsService;

@end
