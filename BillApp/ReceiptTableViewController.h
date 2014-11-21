//
//  ReceiptTableViewController.h
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVItems.h"

@interface ReceiptTableViewController : UITableViewController
@property (weak, nonatomic) NSString * text;
@property (strong, nonatomic) UIImage * receiptImage;
- (void)setProducts:(NSArray*)products setPrices:(NSArray*)pricesArray;
@property (strong, nonatomic) NSArray *prices;
@property (strong, nonatomic) NSArray *product;
@property (strong, nonatomic) NSArray* gvItems;
@end
