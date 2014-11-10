//
//  LoginViewController.m
//  BillApp
//
//  Created by X Code User on 10/3/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

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
    
    //TODO Check if logged in
    if(false)
        //logged in - seque to account screen
        [self performSegueWithIdentifier:@"TOaccount" sender:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.invalidText.hidden=true;
    // Do any additional setup after loading the view.
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
    
    //logged in - seque to account screen
    if(true)
        self.invalidText.hidden=false;
    
    else
        [self performSegueWithIdentifier:@"TOaccount" sender:self];
    
}
@end
