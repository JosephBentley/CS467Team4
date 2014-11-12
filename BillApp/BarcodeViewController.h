//
//  BarcodeViewController.h
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarcodeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *itemName;
@property (weak, nonatomic) IBOutlet UITextField *itemPrice;
@property (weak, nonatomic) IBOutlet UIPickerView *groupName;
@property (weak,nonatomic) NSString* description;
@end
