//
//  GVReceiptTableEditViewController.m
//  BillApp
//
//  Created by X Code User on 11/21/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "GVReceiptTableEditViewController.h"

@interface GVReceiptTableEditViewController ()

@end

@implementation GVReceiptTableEditViewController

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
    self.itemName.text = self.item.name;
    self.cost.text = [NSString stringWithFormat:@"$%.02f", self.item.cost];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                     target:self
                                     action:@selector(saveButtonPressed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

-(void)saveButtonPressed: (id)sender
{
    //check for null values and formatting stuff
    if(![self.itemName.text isEqual: @""] && ![self.cost.text isEqual: @""]){
        self.item.name = self.itemName.text;
        if([[self.cost.text substringToIndex:1] isEqual: @"$"]){
            self.item.cost = [[self.cost.text substringFromIndex:1] doubleValue];
        }
        else{
            self.item.cost = [self.cost.text doubleValue];
        }

        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Invalid"
                                                           message:@"Please enter acceptable values."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
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

@end
