//
//  ShoppingListTableViewController.m
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "ShoppingListTableViewController.h"
#import "ShoppingTableViewCell.h"
@interface ShoppingListTableViewController ()

@end

@implementation ShoppingListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // customizing the table to be displayed
        // set the class to query on
        self.parseClassName = @"ShoppingList";
        
        
        // enable the builtin pull-to-refresh-feature
        self.pullToRefreshEnabled = YES;
        
        // enable pagination
        self.paginationEnabled = YES;
        
        // the number of objects per page.
        self.objectsPerPage = 10;
    }
    return self;
}
-(void) viewDidAppear:(BOOL)animated{
    [self loadObjects];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _editing = false;
    [self loadObjects];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (PFQuery *) queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"ShoppingList"];
    if([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query orderByDescending:@"createAt"];
    return query;
}

- (IBAction)menu:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Account Info",@"Dashboard", @"Bill List", @"Product Entry",nil];
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
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:@"Dashboard"])
        [self performSegueWithIdentifier:@"TOdashboard" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"ShoppingCell";
    ShoppingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *item = object[@"Item_nm"];
    cell.textLabel.text=item;
    BOOL ischecked = [object[@"isChecked"] boolValue];
    if(ischecked)
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType =UITableViewCellAccessoryNone;
    
    return cell;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated { //Implement this method
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        PFQuery *query = [PFQuery queryWithClassName:@"ShoppingList"];
        [query selectKeys:@[@"Item_nm"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (id object in objects) {
                
                NSLog(@"%@", object[@"Item_nm"]);
                if([object[@"Item_nm"] isEqualToString:cell.textLabel.text]){
                    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [self loadObjects];
                        [self.tableView reloadData];
                    }];
                }
                
            }
            
        }];
        
        
        
    }
}
- (void) refreshTableData{
    [self.tableView reloadData];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFQuery *query = [PFQuery queryWithClassName:@"ShoppingList"];
    [query selectKeys:@[@"Item_nm"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (id object in objects) {
            if([object[@"Item_nm"] isEqualToString:cell.textLabel.text]){
                if(cell.accessoryType ==UITableViewCellAccessoryCheckmark){
                    cell.accessoryType =UITableViewCellAccessoryNone;
                    object[@"isChecked"]= [NSNumber numberWithBool:false];
                }
                else{
                    cell.accessoryType =UITableViewCellAccessoryCheckmark;
                    object[@"isChecked"]= [NSNumber numberWithBool:true];
                }
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                }];
            }
            
        }
        
    }];
}


- (IBAction)addPressed:(id)sender {
    [self performSegueWithIdentifier:@"toView" sender:self];
}
@end