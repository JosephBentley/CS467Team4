//
//  ReceiptTableViewController.h
//  BillApp
//
//  Created by X Code User on 9/29/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptTableViewController : UITableViewController
@property (weak, nonatomic) NSString * text;
@property (strong, nonatomic) UIImage * receiptImage;
- (void)setDetailItem:(NSArray*)newDetailItem;
@property (strong, nonatomic) NSArray *myWords;
@end
