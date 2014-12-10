//
//  ReceiptTableViewController.h
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVItems.h"
#import "GVGroupsService.h"
#import "GVItemsService.h"
#import <QuartzCore/QuartzCore.h>

@interface ReceiptTableViewController : UITableViewController <UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray* gvItems;

//UIPicker stuff
@property (weak, nonatomic) IBOutlet UIPickerView *groups;
@property (strong, nonatomic) GVGroupsService* groupService;
@property (strong, nonatomic) GVItemsService* itemsService;
@property (strong, nonatomic) NSArray* groupNames;
@property (strong, nonatomic) NSString* selectedGroup;




//@property (weak, nonatomic) NSString * text;
//@property (strong, nonatomic) UIImage * receiptImage;
//- (void)setProducts:(NSArray*)products setPrices:(NSArray*)pricesArray;
//@property (strong, nonatomic) NSArray *prices;
//@property (strong, nonatomic) NSArray *product;
//@property (weak, nonatomic) IBOutlet UIButton *selectGroup;

@end
