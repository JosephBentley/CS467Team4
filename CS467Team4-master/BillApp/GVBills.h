//
//  GVBills.h
//  ParseLogInAttempt
//
//  Created by X Code User on 10/14/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVBills : NSObject
@property (strong, nonatomic)NSString* name;
@property (nonatomic, assign)double cost;
@property (nonatomic, assign)int interval;
@property (strong, nonatomic)NSDate* nextPayDate;
-(GVBills*)init;
-(id)initWithName:(NSString*)billName cost:(double)cost interval:(int)interval nextPayDate:(NSDate*)nextPayDate;
@end
