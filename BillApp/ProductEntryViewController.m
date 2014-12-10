//
//  ProductEntryViewController.m
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "ProductEntryViewController.h"
#import "CameraViewController.h"
#import "GVGroups.h"

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
    
    self.groupService = [[GVGroupsService alloc] init];
    self.itemsService = [[GVItemsService alloc] init];
    self.groups.delegate = self;
    self.groups.dataSource = self;
    //self.groupNames = @[@"Australia (AUD)", @"China (CNY)",
    //  @"France (EUR)", @"Great Britain (GBP)", @"Japan (JPY)"];
    [self.groupService queryUserJoinedGroupsWithBlock:^(NSMutableArray *groupsJoined, NSError *error) {
        self.groupNames = groupsJoined;
        [self.groups reloadAllComponents];
    }];
    
    
    //Round Save Button
    _saveButton.layer.borderWidth = 1.0f;
    _saveButton.layer.cornerRadius = 10;
    _saveButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    if (self.productNameString != nil) {
        self.productName.text = self.productNameString;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker Delegate methods

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if(self.groupNames.count == 0){
        _groups.userInteractionEnabled = NO;
        return self.groupNames.count;
    }
    else{
        _groups.userInteractionEnabled = YES;
        return self.groupNames.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    GVGroups* group = self.groupNames[row];
    return group.name;
    //return self.groupNames[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    GVGroups* group = self.groupNames[row];
    self.selectedGroup = group.name;
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
    if (![self.productName.text isEqualToString:@""] && ![self.price.text isEqualToString:@""]) {
        GVItems* newItem = [[GVItems alloc] initWithName:self.productName.text cost:[self.price.text doubleValue] productID:@"034856543" sharedItem:@0 boughtBy:[PFUser currentUser][@"username"] group:self.selectedGroup];
        [self.itemsService saveItemInBackgroundWithGVItemWithBlock:newItem block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                self.price.text = @"";
                self.productName.text = @"";
            }
            else {
                // tell user something went wrong
                NSLog(@"Error Saving Product... somewhere.");
            }
        }];
    }
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
                                                    otherButtonTitles:@"Account Info",@"Dashboard" ,@"Bill List",@"Shopping List",nil];
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
