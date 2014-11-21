//
//  CreateAccountViewController.m
//  BillApp
//
//  Created by X Code User on 10/3/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "AccountViewController.h"

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

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
    // Do any additional setup after loading the view.
    self.userService = [[GVUserService alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)savePressed:(id)sender {
    NSLog(@"Save pressed.");
    [self.userService createNewUserWithUserNameWithBlock:self.username.text password:self.password.text email:self.email.text block:^(BOOL succeeded, NSError *error) {
        if(!error) {
            [self performSegueWithIdentifier:@"createAccountTOaccount" sender:self];
        }
        else {
            // something went wrong.
        }
    }];
}

#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"createAccountTOaccount"])
//    {
//
//        AccountViewController *vc = [segue destinationViewController];
//        vc.email=self.email.text;
//    }
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
