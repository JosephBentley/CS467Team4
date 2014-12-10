//
//  SelectGroupViewController.m
//  BillApp
//
//  Created by X Code User on 12/8/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import "SelectGroupViewController.h"
#import "CameraViewController.h"
#import "GVGroups.h"

@interface SelectGroupViewController ()

@end

@implementation SelectGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.groupService = [[GVGroupsService alloc] init];
    self.itemsService = [[GVItemsService alloc] init];
    self.groups.delegate = self;
    self.groups.dataSource = self;
    //self.groupNames = @[@"Australia (AUD)", @"China (CNY)",
    //  @"France (EUR)", @"Great Britain (GBP)", @"Japan (JPY)"];
    [self.groupService queryUserJoinedGroupsWithBlock:^(NSMutableArray *groupsJoined, NSError *error) {
        self.groupNames = groupsJoined;
        [self.groups reloadAllComponents];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker Delegate methods

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if(self.groupNames.count == 0){
        _groups.userInteractionEnabled = NO;
        return self.groupNames.count;
    }
    else{
        _groups.userInteractionEnabled = YES;
        return self.groupNames.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    GVGroups* group = self.groupNames[row];
    return group.name;
    //return self.groupNames[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    GVGroups* group = self.groupNames[row];
    self.selectedGroup = group.name;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
