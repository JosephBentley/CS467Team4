//
//  ShoppingListViewController.h
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListViewController : UIViewController 
- (IBAction)cancelPressed:(id)sender;
- (IBAction)savePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *itemText;
@end
