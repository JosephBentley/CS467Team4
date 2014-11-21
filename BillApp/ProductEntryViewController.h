//
//  ProductEntryViewController.h
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVGroupsService.h"
#import "GVItemsService.h"


@interface ProductEntryViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *productName;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UIPickerView *groups;
- (IBAction)saveProduct:(id)sender;
- (IBAction)PhotoButton:(id)sender;
//Use to determine where to go after taking a picture
@property (weak,nonatomic) NSString *dest;

@property (strong, nonatomic) GVGroupsService* groupService;
@property (strong, nonatomic) GVItemsService* itemsService;
@property (strong, nonatomic) NSArray* groupNames;
@property (strong, nonatomic) NSString* selectedGroup;
@end
