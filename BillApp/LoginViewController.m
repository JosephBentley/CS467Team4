//
//  LoginViewController.m
//  BillApp
//
//  Created by X Code User on 10/3/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController (){
}
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.password.text = @"";
    
    //TODO Check if logged in
    if([PFUser currentUser] != nil)
        //logged in - seque to account screen
        [self performSegueWithIdentifier:@"TOaccount" sender:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.invalidText.hidden=true;
    self.userService = [[GVUserService alloc] init];
    // Do any additional setup after loading the view.
    
    //Round Login Button
    _loginButton.layer.borderWidth = 1.0f;
    _loginButton.layer.cornerRadius = 5;
    _loginButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    //Round createAcc Button
    _createAccButton.layer.borderWidth = 1.0f;
    _createAccButton.layer.cornerRadius = 5;
    _createAccButton.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)loginPressed:(id)sender {
    //TODO verify login info
    NSLog(@"Inside loginPressed");
    
    //logged in - seque to account screen
    [self.userService logInWithUsernameInBackgroundWithBlock:self.username.text password:self.password.text block:^(NSError *error) {
        if(!error) {
            [self performSegueWithIdentifier:@"TOaccount" sender:self];
        }
        else {
            self.invalidText.hidden=false;
        }
    }];
    
}
@end
