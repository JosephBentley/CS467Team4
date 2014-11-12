//
//  AppDelegate.h
//  BillApp
//
//  Created by X Code User on 9/17/14.
//  Copyright (c) 2014 Team4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, readonly) int networkActivityCounter;
@property (strong, nonatomic) UIWindow *window;
- (void) incrementNetworkActivity;
- (void) decrementNetworkActivity;
- (void) resetNetworkActivity;
@end
