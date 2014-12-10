//
//  GroupTableViewController.m
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "GroupTableViewController.h"
#import "AccountViewController.h"
#import "ReportTableViewController.h"
#import "UIGroupInviteUserViewController.h"
#import "GVAcceptInvitesTableViewController.h"
#import "PendingSearchViewController.h"

@interface GroupTableViewController (){

}

@end

@implementation GroupTableViewController

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
    
    self.itemsService = [[GVItemsService alloc] init];
    self.groupsService = [[GVGroupsService alloc] init];
    
    UIBarButtonItem *inviteButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                   target:self
                                   action:@selector(inviteToGroupButtonPressed:)];
    UIBarButtonItem *acceptInvites = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                     target:self
                                     action:@selector(acceptInvitesButtonPressed:)];
    UIBarButtonItem *paymentsButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                      target:self
                                      action:@selector(paymentsButtonpressed:)];
    self.navigationItem.rightBarButtonItems = @[paymentsButton,acceptInvites, inviteButton];
    //self.navigationItem.rightBarButtonItem = inviteButton;
    
    
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)inviteToGroupButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"TOinviteUser" sender:self];
}

-(void)acceptInvitesButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"TOacceptInvites" sender:self];
}
-(void)paymentsButtonpressed:(id)sender
{
    [self performSegueWithIdentifier:@"TOdoubleDate" sender:self];
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
    return self.group.users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GVuser" forIndexPath:indexPath];
    cell.textLabel.text = self.group.users[indexPath.row];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"TOreport"])
    {
        ReportTableViewController *vc = [segue destinationViewController];
        vc.title = self.selectedRow;
        vc.items = self.userItems;

    }
    if ([[segue identifier] isEqualToString:@"TOinviteUser"]){
        UIGroupInviteUserViewController* vc = [segue destinationViewController];
        vc.title = self.title;
    }
    if ([[segue identifier] isEqualToString:@"TOacceptInvites"]){
        GVAcceptInvitesTableViewController* vc = [segue destinationViewController];
        vc.title = self.title;
        [self.groupsService queryPendingJoinRequestsWithGroupNameWithBlock:self.title block:^(NSMutableArray *object, NSError *error) {
            vc.invites = object;
            [vc.tableView reloadData];
        }];
    }
    if ([[segue identifier] isEqualToString:@"TOdoubleDate"]){
        PendingSearchViewController* vc = [segue destinationViewController];
        vc.title = self.title;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = self.group.users[indexPath.row];
    [self.itemsService queryGroupItemsWithUserNameWithBlock:self.selectedRow group:self.title block:^(NSMutableArray *userItemsInGroup, NSError *error) {
        self.userItems = userItemsInGroup;
        [self performSegueWithIdentifier:@"TOreport" sender:self];
    }];
}

@end
