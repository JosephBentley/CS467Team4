//
//  GVAcceptInvitesTableViewController.h
//  BillApp
//
//  Created by X Code User on 11/20/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVGroupsService.h"

@interface GVAcceptInvitesTableViewController : UITableViewController <UIActionSheetDelegate>
@property (strong, nonatomic)NSMutableArray* invites;
@property (strong, nonatomic)GVGroupsService* groupService;
@end
