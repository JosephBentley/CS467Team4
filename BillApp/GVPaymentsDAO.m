//
//  GVPaymentsDAO.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVPaymentsDAO.h"
#import <Parse/Parse.h>
#import "GVPayments.h"

@implementation GVPaymentsDAO

static NSString* PAYMENTS_TABLE_NAME = @"Payments";
static NSString* GROUPS_COLUMN_NAME = @"group";
static NSString* BOUGHT_BY_COLUMN_NAME = @"boughtBy";

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
        self.sharedGVParseDAOUtilities = [GVParseDAOUtilities sharedGVParseDAOUtilities];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


#pragma mark Parse Methods

-(void)savePaymentInBackgroundWithGVPaymentsWithBlock:(GVPayments*)payment block:(void (^) (BOOL succeeded, NSError* error)) block
{
    NSNumber* nsTotal = [[NSNumber alloc] initWithDouble:payment.total];
    NSNumber* nsInterestRate = [[NSNumber alloc] initWithDouble:payment.interestRate];
    NSNumber* nsInterval = [[NSNumber alloc] initWithInt:payment.interval];
    
    PFObject *paymentObject = [PFObject objectWithClassName:@"Payments"];
    paymentObject[@"payment_nm"] = payment.name;
    paymentObject[@"total_nb"] = nsTotal;
    paymentObject[@"interestRate_nb"] = nsInterestRate;
    paymentObject[@"interval_nb"] = nsInterval;
    paymentObject[@"nextPayDate"] = payment.nextPayDate;
    [self.sharedGVParseDAOUtilities saveObjectInBackgroundWithUserNameWithBlock:[PFUser currentUser][@"username"] group:payment.group object:paymentObject boughtByColumnName:BOUGHT_BY_COLUMN_NAME groupsColumnName:GROUPS_COLUMN_NAME block:block];
}

/*
 Get all user payments.
 */
-(void)queryAllUserPaymentsWithBlock:(void (^)(NSMutableArray* items, NSError* error) ) block
{
    PFQuery *query = [PFQuery queryWithClassName:PAYMENTS_TABLE_NAME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray* userItems = [[NSMutableArray alloc] initWithArray:[self convertToGVPaymentsArrayWithParseObjectsArray:objects]];
            block(userItems, error);
        } else {
            NSString* errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
			block(nil, error);
        }
    }];
}

/*
 Get all group payments.
 */
-(void)queryGroupPaymentsWithGroupNameWithBlock:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVParseDAOUtilities queryGroupObjectsWithGroupNameWithBlock:groupname table:PAYMENTS_TABLE_NAME block:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray* userItems = [[NSMutableArray alloc] initWithArray:[self convertToGVPaymentsArrayWithParseObjectsArray:objects]];
            block(userItems, error);
        } else {
            NSString* errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            block(nil, error);
        }
    }];
}

/*
 Get all group payments bought by a certain user.
 */
-(void)queryGroupPaymentsWithUserNameWithBlock:(NSString*)username group:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVParseDAOUtilities queryGroupObjectsWithUserNameWithBlock:username group:groupname table:PAYMENTS_TABLE_NAME block:^(NSArray *userObjectsInGroup, NSError *error) {
        if (!error) {
            NSMutableArray* userItems = [[NSMutableArray alloc] initWithArray:[self convertToGVPaymentsArrayWithParseObjectsArray:userObjectsInGroup]];
            block(userItems, error);
        } else {
            NSString* errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            block(nil, error);
        }
    }];
}

/*
 Convert an array of PFObjects to a mutable array of GVItems.
 */
-(NSMutableArray*)convertToGVPaymentsArrayWithParseObjectsArray:(NSArray*)objects
{
    NSLog(@"Successfully retrieved %d items.", objects.count);
    NSMutableArray* userItems = [[NSMutableArray alloc] init];
    for (PFObject *object in objects) {
        NSString* boughtByString = nil;
        NSString* groupString = nil;
        
        PFObject* user = [[object objectForKey:BOUGHT_BY_COLUMN_NAME] fetchIfNeeded];
        if (user != nil) {
            boughtByString = user[@"username"];
        }
        PFObject* group = [[object objectForKey:GROUPS_COLUMN_NAME] fetchIfNeeded];
        if (group != nil) {
            groupString = group[@"group_nm"];
        }
        GVPayments* row = [[GVPayments alloc] initWithName:object[@"payment_nm"]
                                                     total:[object[@"total_nb"] doubleValue]
                                              interestRate:[object[@"interestRate_nb"] doubleValue]
                                                  interval:[object[@"interval_nb"]  intValue]
                                               nextPayDate:object[@"nextPayDate"]
                                                  boughtBy:boughtByString
                                                     group:groupString];
        [userItems addObject: row];
    }
    return userItems;
}
@end
