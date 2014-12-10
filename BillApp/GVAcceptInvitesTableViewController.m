//
//  GVAcceptInvitesTableViewController.m
//  BillApp
//
//  Created by X Code User on 11/20/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "GVAcceptInvitesTableViewController.h"

@interface GVAcceptInvitesTableViewController () {
    NSString *selectedUser;
}
@end

@implementation GVAcceptInvitesTableViewController

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
    self.title = @"Manage group join requests";
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.invites.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"acceptInvitesCell" forIndexPath:indexPath];
    cell.textLabel.text = self.invites[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Accept",@"Decline",nil];
    actionSheet.tag = 200;
    selectedUser = self.invites[indexPath.row];
    [actionSheet showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 200) {
        
        //TODO - update db. accept the pending invite
        if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Accept"]){
            [self.groupService acceptGroupJoinRequestFromUserWithBlock:selectedUser group:self.navigationItem.title block:^(BOOL succeeded, NSError *error) {
                [self.invites removeObject:selectedUser];
                [self.tableView reloadData];
            }];
        }
        //TODO - update db. decline the pending invite
        if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Decline"]){
            [self.groupService declineGroupJoinRequestFromUserWithBlock:selectedUser group:self.navigationItem.title block:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self.invites removeObject:selectedUser];
                    [self.tableView reloadData];
                }
            }];
        }
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
