//
//  GVPayments.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/14/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVPayments.h"
#import <Parse/Parse.h>

@implementation GVPayments

-(GVPayments*)init {
    if (self = [super init]) {
        self.name = nil;
        self.total = -1.0;
        self.interestRate = -1.0;
        self.interval = -1;
        self.nextPayDate = nil;
    }
    return self;
}

-(id)initWithName:(NSString*)paymentName total:(double)total interestRate:(double)interestRate interval:(int)interval nextPayDate:(NSDate*)nextPayDate;
{
    if (self = [super init]) {
        self.name = paymentName;
        self.total = total;
        self.interestRate = interestRate;
        self.interval = interval;
        self.nextPayDate = nextPayDate;
    }
    return self;
}

@end
