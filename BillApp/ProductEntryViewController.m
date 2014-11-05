//
//  ProductEntryViewController.m
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "ProductEntryViewController.h"
#import "CameraViewController.h"

@interface ProductEntryViewController ()

@end

@implementation ProductEntryViewController

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
    if ([[segue identifier] isEqualToString:@"productEntryTOcamera"])
    {
        CameraViewController *vc = [segue destinationViewController];
        vc.dest=self.dest;
    }
}


- (IBAction)saveProduct:(id)sender {
}
- (IBAction)PhotoButton:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Receipt Photo", @"Scan Barcode", @"Existing Receipt",nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

- (IBAction)menu:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Account Info",@"Dashboard" ,@"Bill List" ,@"Pending List",@"Shopping List",nil];
    actionSheet.tag = 200;
    
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 200) {
        if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Dashboard"])
            [self performSegueWithIdentifier:@"TOdashboard" sender:self];
        if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Account Info"])
            [self performSegueWithIdentifier:@"TOaccount" sender:self];
        if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Bill List"])
            [self performSegueWithIdentifier:@"TObill" sender:self];
        if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Pending List"])
            [self performSegueWithIdentifier:@"TOpending" sender:self];
        if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Shopping List"])
            [self performSegueWithIdentifier:@"TOshopping" sender:self];
    }
    if (actionSheet.tag == 100) {
        
        if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Take Receipt Photo"])[self performSegueWithIdentifier:@"TOtakereceipt" sender:self];
        if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Scan Barcode"])[self performSegueWithIdentifier:@"TOscanbarcode" sender:self];
        if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Existing Receipt"])[self performSegueWithIdentifier:@"TOexistingreceipt" sender:self];

    //self.dest=[actionSheet buttonTitleAtIndex:buttonIndex];
    //[self performSegueWithIdentifier:@"productEntryTOcamera" sender:self];
    }
}

@end
