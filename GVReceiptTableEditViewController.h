//
//  GVReceiptTableEditViewController.h
//  BillApp
//
//  Created by X Code User on 11/21/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVitems.h"

@interface GVReceiptTableEditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *itemName;
@property (weak, nonatomic) IBOutlet UITextField *cost;
@property (strong, nonatomic) GVItems* item;
@end
