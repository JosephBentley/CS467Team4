//
//  TesseractViewController.h
//  BillApp
//
//  Created by X Code User on 11/2/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TesseractViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *textField;
@property (strong, nonatomic) UIImage * receiptImage;
- (void)setDetailItem:(UIImage*)newDetailItem;
@end
