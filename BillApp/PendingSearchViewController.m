//
//  PendingSearchViewController.m
//  BillApp
//
//  Created by X Code User on 12/8/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "PendingSearchViewController.h"
#import "PendingTableViewController.h"

@interface PendingSearchViewController ()

@end

@implementation PendingSearchViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PendingTableViewController *vc = [segue destinationViewController];
    vc.startDate=[self.endDate date];
    vc.endDate=[self.startDate date];

}


- (IBAction)refreshButtonPressed:(id)sender {
    NSComparisonResult result;
    NSDate * s =[self.startDate date];
    NSDate * e =[self.endDate date];
    result = [s compare:e];
    if(result==NSOrderedDescending){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Alert"
                                                       message: @"Invalid dates"
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK",nil];
        
        [alert show];
    }
    else
    [self performSegueWithIdentifier:@"TOpending" sender:self];
}
@end
