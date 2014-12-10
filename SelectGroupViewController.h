//
//  SelectGroupViewController.h
//  BillApp
//
//  Created by X Code User on 12/8/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVGroupsService.h"
#import "GVItemsService.h"
#import <QuartzCore/QuartzCore.h>

@interface SelectGroupViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource>


@property (weak, nonatomic) IBOutlet UIPickerView *groups;
@property (strong, nonatomic) GVGroupsService* groupService;
@property (strong, nonatomic) GVItemsService* itemsService;
@property (strong, nonatomic) NSArray* groupNames;
@property (strong, nonatomic) NSString* selectedGroup;


@end
