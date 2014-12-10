//
//  DashboardTableViewController.m
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "DashboardTableViewController.h"

@interface DashboardTableViewController (){
GVGroups *user;
}
@end

@implementation DashboardTableViewController

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
    self.groupService = [[GVGroupsService alloc] init];
    [self.groupService queryUserJoinedGroupsWithBlock:^(NSMutableArray *groupsJoined, NSError *error) {
        self.groups = groupsJoined;
        [self.tableView reloadData];
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.groups.count;
}
- (IBAction)menu:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Account Info", @"Bill List", @"Product Entry",@"Shopping List",nil];
    actionSheet.tag = 100;
    
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"From didDismissWithButtonIndex - Selected: %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
    }
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Account Info"])
        [self performSegueWithIdentifier:@"TOaccount" sender:self];
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Bill List"])
        [self performSegueWithIdentifier:@"TObill" sender:self];
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Product Entry"])
        [self performSegueWithIdentifier:@"TOentry" sender:self];
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Shopping List"])
        [self performSegueWithIdentifier:@"TOshopping" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupsCell" forIndexPath:indexPath];
    GVGroups* group = self.groups[[indexPath row]];
    cell.textLabel.text = group.name;
    //cell.detailTextLabel.text = group.name;
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    user= self.groups[indexPath.row];
    [self performSegueWithIdentifier:@"TOusers" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"TOusers"])
    {
        GroupTableViewController *vc = [segue destinationViewController];
        vc.group = user;
        vc.title = user.name;
    }
}


@end
