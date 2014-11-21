//
//  GroupTableViewController.h
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVGroups.h"
#import "GVItemsService.h"

@interface GroupTableViewController : UITableViewController
@property (strong, nonatomic)GVGroups* group;
@property (strong, nonatomic)GVItemsService* itemsService;
@property (strong, nonatomic)NSString* selectedRow;
@property (strong, nonatomic)NSMutableArray* userItems;
@end
