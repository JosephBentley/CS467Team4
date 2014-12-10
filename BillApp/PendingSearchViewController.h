//
//  PendingSearchViewController.h
//  BillApp
//
//  Created by X Code User on 12/8/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingSearchViewController : UIViewController
- (IBAction)refreshButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDate;

@end
