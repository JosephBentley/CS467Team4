//
//  ExistingReceiptViewController.h
//  BillApp
//
//  Created by X Code User on 10/25/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExistingReceiptViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)scanReceipt:(UIButton *)sender;
- (IBAction)chooseReceipt:(UIButton *)sender;
@property (strong, nonatomic) NSArray *myWords;

@end
