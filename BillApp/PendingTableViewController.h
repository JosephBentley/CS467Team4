//
//  PendingTableViewController.h
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingTableViewController : UITableViewController <UIActionSheetDelegate>
@property (strong, nonatomic) NSDate * startDate;
@property (strong, nonatomic) NSDate * endDate;
@end
