//
//  TakeReceiptViewController.h
//  BillApp
//
//  Created by X Code User on 10/27/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVItems.h"

@interface TakeReceiptViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)scanReceipt:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *scanReceiptLabel;
@property (strong, nonatomic) NSArray *myWords;
@property (strong, nonatomic) NSMutableArray *entries;
@property (strong, nonatomic) NSMutableArray *prices;
@property (strong, nonatomic) NSMutableArray *product;
@property (strong, nonatomic) NSMutableArray* gvItems;
@end
