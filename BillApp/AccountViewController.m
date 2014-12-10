//
//  AccountViewController.m
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "AccountViewController.h"
#import "DashboardTableViewController.h"
#import "GroupInvitesTableViewController.h"

@interface AccountViewController (){
    NSMutableArray*invitesgroup;
}

@end

@implementation AccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailAddress.text=self.email;
    self.userService = [[GVUserService alloc] init];
    self.groupService = [[GVGroupsService alloc] init];
    
    //Round _logoutButton Button
    _logoutButton.layer.borderWidth = 1.0f;
    _logoutButton.layer.cornerRadius = 5;
    _logoutButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    //Round _createButton Button
    _createButton.layer.borderWidth = 1.0f;
    _createButton.layer.cornerRadius = 5;
    _createButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    //Round _manageButton Button
    _manageButton.layer.borderWidth = 1.0f;
    _manageButton.layer.cornerRadius = 5;
    _manageButton.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createGroup:(id)sender {
    [self.groupService createNewGroupWithGroupNameWithBlock:self.groupName.text block:^(BOOL succeeded, NSError *error) {
        if (!error) {
            self.groupName.text = @"";
        }
        else {
            //couldn't create group for some reason
        }
    }];
}

- (IBAction)saveButton:(id)sender {
    self.enableReport= self.emailAddress.text;
}
- (IBAction)logoutButton:(id)sender {
    NSLog(@"logoutButton Pressed");
    [self.userService logoutCurrentUserWithBlock:^(BOOL succeeded) {
        if (succeeded) {
            [[self navigationController] popToRootViewControllerAnimated:YES];
        }
        else {
            // not logged out... tell user something errored.
        }
    }];
}
- (IBAction)menu:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Dashboard", @"Bill List", @"Product Entry",@"Shopping List",nil];
    actionSheet.tag = 100;
    
    [actionSheet showInView:self.view];
}

- (IBAction)addGroup:(id)sender {
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"From didDismissWithButtonIndex - Selected: %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
    }
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Dashboard"])
        [self performSegueWithIdentifier:@"TOdashboard" sender:self];
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Bill List"])
        [self performSegueWithIdentifier:@"TObill" sender:self];
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Product Entry"])
        [self performSegueWithIdentifier:@"TOentry" sender:self];
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Shopping List"])
        [self performSegueWithIdentifier:@"TOshopping" sender:self];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)invitesPressed:(id)sender {
    [self.groupService queryInvitedToGroupsWithBlock:^(NSMutableArray *groupsJoined, NSError *error) {
        invitesgroup =groupsJoined;
        [self performSegueWithIdentifier:@"TOinvites" sender:self];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"TOinvites"])
    {
        GroupInvitesTableViewController *vc = [segue destinationViewController];
        vc.groups=invitesgroup;
        vc.title = @"Group Invites";
    }
}


@end
