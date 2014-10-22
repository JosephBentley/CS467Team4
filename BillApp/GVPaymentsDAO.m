//
//  GVPaymentsDAO.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVPaymentsDAO.h"
#import <Parse/Parse.h>

@implementation GVPaymentsDAO

#pragma mark Singleton Methods

+ (id)sharedGVPaymentsDAO {
    static GVPaymentsDAO *sharedGVPaymentsDAO = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGVPaymentsDAO = [[self alloc] init];
    });
    return sharedGVPaymentsDAO;
}

- (id)init {
    if (self = [super init]) {
        // set queries (or make them static final)
        
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


#pragma mark Parse Methods

-(bool)savePaymentInBackgroundWithGVPayments:(GVPayments*)payment error:(NSError**) error
{
    if (payment.name == nil || payment.total < 0 || payment.interestRate < 0 || payment.interval < 0 || payment.nextPayDate == nil)
        return false;
    else {
        NSNumber* nsTotal = [[NSNumber alloc] initWithDouble:payment.total];
        NSNumber* nsInterestRate = [[NSNumber alloc] initWithDouble:payment.interestRate];
        NSNumber* nsInterval = [[NSNumber alloc] initWithInt:payment.interval];
        
        PFObject *paymentObject = [PFObject objectWithClassName:@"Payments"];
        paymentObject[@"payment_nm"] = payment.name;
        paymentObject[@"total_nb"] = nsTotal;
        paymentObject[@"interestRate_nb"] = nsInterestRate;
        paymentObject[@"interval_nb"] = nsInterval;
        paymentObject[@"nextPayDate"] = payment.nextPayDate;
        [paymentObject saveInBackground];
    }
    return true;
}
@end
