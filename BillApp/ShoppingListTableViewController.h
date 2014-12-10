//
//  ShoppingListTableViewController.h
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ShoppingListTableViewController : PFQueryTableViewController <UIActionSheetDelegate>
@property PFObject *object;
- (IBAction)addPressed:(id)sender;
@property(nonatomic, getter=isEditing) BOOL editing;
@end
