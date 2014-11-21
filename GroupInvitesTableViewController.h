//
//  GroupInvitesTableViewController.h
//  BillApp
//
//  Created by X Code User on 11/19/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVGroupsService.h"

@interface GroupInvitesTableViewController : UITableViewController
@property (strong, nonatomic)NSMutableArray* groups;
@property (strong, nonatomic)GVGroupsService* groupService;
@end
