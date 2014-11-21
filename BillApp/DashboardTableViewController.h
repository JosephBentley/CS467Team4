//
//  DashboardTableViewController.h
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupTableViewController.h"
#import "GVGroupsService.h"
#import "GVGroups.h"

@interface DashboardTableViewController : UITableViewController <UIActionSheetDelegate>
@property (strong, nonatomic) GVGroupsService* groupService;
@property (strong, nonatomic) NSArray* groups;
@end
