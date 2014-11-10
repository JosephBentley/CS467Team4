//
//  AccountViewController.m
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "AccountViewController.h"
#import "DashboardTableViewController.h"

@interface AccountViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createGroup:(id)sender {
}

- (IBAction)saveButton:(id)sender {
    self.enableReport= self.emailAddress.text;
}
- (IBAction)menu:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Dashboard", @"Bill List", @"Product Entry",@"Pending List",@"Shopping List",nil];
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
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Pending List"])
        [self performSegueWithIdentifier:@"TOpending" sender:self];
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Shopping List"])
        [self performSegueWithIdentifier:@"TOshopping" sender:self];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
