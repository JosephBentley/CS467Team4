//
//  GVBillsDAO.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVBillsDAO.h"
#import <Parse/Parse.h>

@implementation GVBillsDAO

#pragma mark Singleton Methods

+ (id)sharedGVBillsDAO {
    static GVBillsDAO *sharedGVBillsDAO = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGVBillsDAO = [[self alloc] init];
    });
    return sharedGVBillsDAO;
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

-(bool)saveBillInBackgroundWithGVBills:(GVBills*)bill error:(NSError**) error
{
    if (bill.name == nil || bill.cost < 0 || bill.interval < 0 || bill.nextPayDate == nil)
        return false;
    else {
        NSNumber* nsCost = [[NSNumber alloc] initWithDouble:bill.cost];
        NSNumber* nsInterval = [[NSNumber alloc] initWithInt:bill.interval];
        PFObject *billObject = [PFObject objectWithClassName:@"Bills"];
        billObject[@"bill_nm"] = bill.name;
        billObject[@"cost_nb"] = nsCost;
        billObject[@"interval_nb"] = nsInterval;
        billObject[@"nextPayDate"] = bill.nextPayDate;
        [billObject saveInBackground];
    }
    return true;
}
@end
