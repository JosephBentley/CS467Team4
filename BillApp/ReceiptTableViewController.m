//
//  ReceiptTableViewController.m
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "ReceiptTableViewController.h"
#import "tesseract.h"
#import "GVReceiptTableEditViewController.h"
#import "GVGroups.h"


@interface ReceiptTableViewController ()

@end

@implementation ReceiptTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.navigationItem.hidesBackButton = YES;
    
    
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

    
    
}
- (IBAction)donePressed:(id)sender {
    int i = 0;
    for (GVItems* item in self.gvItems) {
        item.group = self.selectedGroup;
        item.sharedFlag = @1;
        item.productID = @"012345";
        [self.itemsService saveItemInBackgroundWithGVItemWithBlock:item block:^(BOOL succeeded, NSError *error) {
            NSLog(@"Saved Item %d", i);
        }];
        i++;
    }
    [self performSegueWithIdentifier:@"TOdashboard" sender:self];
    //[self.navigationController performSegueWithIdentifier:@"TOreceiptEdit" sender:self];
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)setProducts:(NSArray*)products setPrices:(NSArray*)pricesArray
{
    if (self.product != products) {
        self.product  = products;
    }
    if (self.prices != pricesArray) {
        self.prices  = pricesArray;
    }
}
*/

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.gvItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    GVItems* item = self.gvItems[indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.02f", item.cost];
    
    //cell.textLabel.text = [_product objectAtIndex:indexPath.row];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@",[_prices objectAtIndex:indexPath.row]];//@"Item";
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.gvItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TOreceiptEdit"]){
        GVReceiptTableEditViewController* vc = [segue destinationViewController];
        vc.item = self.gvItems[[self.tableView indexPathForSelectedRow].row];
    }
}


@end
