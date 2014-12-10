//
//  UIGroupInviteUserViewController.m
//  BillApp
//
//  Created by X Code User on 11/20/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "UIGroupInviteUserViewController.h"

@implementation UIGroupInviteUserViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.groupsService = [[GVGroupsService alloc] init];
    //self.username.delegate = self;
}

- (IBAction)inviteUserPressed:(id)sender {
    if (![self.username.text isEqualToString:@""]){
        [self.groupsService inviteToGroupWithUserNameWithBlock:self.username.text groupName:self.title block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                
            }
        }];
    }
}
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    //[self.view endEditing:YES];
//    return YES;
//}

@end
