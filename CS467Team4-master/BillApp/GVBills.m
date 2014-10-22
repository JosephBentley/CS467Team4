//
//  GVBills.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/14/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVBills.h"
#import <Parse/Parse.h>

@implementation GVBills

-(GVBills*)init {
    if (self = [super init]) {
        self.name = nil;
        self.cost = -1.0;
        self.interval = -1;
        self.nextPayDate = nil;
    }
    return self;
}

-(id)initWithName:(NSString*)name cost:(double)cost interval:(int)interval nextPayDate:(NSDate*)nextPayDate
{
    if (self = [super init]) {
        self.name = name;
        self.cost = cost;
        self.interval = interval;
        self.nextPayDate = nextPayDate;
    }
    return self;
}

@end
