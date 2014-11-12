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

static NSString* BILLS_TABLE_NAME = @"Bills";
static NSString* GROUPS_COLUMN_NAME = @"group";
static NSString* BOUGHT_BY_COLUMN_NAME = @"boughtBy";

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
        self.sharedGVParseDAOUtilities = [GVParseDAOUtilities sharedGVParseDAOUtilities];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


#pragma mark Parse Methods

-(void)saveBillInBackgroundWithGVBillsWithBlock:(GVBills*)bill block:(void (^) (BOOL succeeded, NSError* error)) block
{
    NSNumber* nsCost = [[NSNumber alloc] initWithDouble:bill.cost];
    NSNumber* nsInterval = [[NSNumber alloc] initWithInt:bill.interval];
    PFObject *billObject = [PFObject objectWithClassName:@"Bills"];
    billObject[@"bill_nm"] = bill.name;
    billObject[@"cost_nb"] = nsCost;
    billObject[@"interval_nb"] = nsInterval;
    billObject[@"nextPayDate"] = bill.nextPayDate;
    [self.sharedGVParseDAOUtilities saveObjectInBackgroundWithUserNameWithBlock:[PFUser currentUser][@"username"] group:bill.group object:billObject boughtByColumnName:BOUGHT_BY_COLUMN_NAME groupsColumnName:GROUPS_COLUMN_NAME block:block];
}

/*
 Get all user bills.
 */
-(void)queryAllUserBillsWithBlock:(void (^)(NSMutableArray* items, NSError* error) ) block
{
    PFQuery *query = [PFQuery queryWithClassName:BILLS_TABLE_NAME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray* userItems = [[NSMutableArray alloc] initWithArray:[self convertToGVBillsArrayWithParseObjectsArray:objects]];
            block(userItems, error);
        } else {
            NSString* errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
			block(nil, error);
        }
    }];
}

/*
 Get all group bills.
 */
-(void)queryGroupBillsWithGroupNameWithBlock:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVParseDAOUtilities queryGroupObjectsWithGroupNameWithBlock:groupname table:BILLS_TABLE_NAME block:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray* userItems = [[NSMutableArray alloc] initWithArray:[self convertToGVBillsArrayWithParseObjectsArray:objects]];
            block(userItems, error);
        } else {
            NSString* errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            block(nil, error);
        }
    }];
}

/*
 Get all group bills bought by a certain user.
 */
-(void)queryGroupBillsWithUserNameWithBlock:(NSString*)username group:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVParseDAOUtilities queryGroupObjectsWithUserNameWithBlock:username group:groupname table:BILLS_TABLE_NAME block:^(NSArray *userObjectsInGroup, NSError *error) {
        if (!error) {
            NSMutableArray* userItems = [[NSMutableArray alloc] initWithArray:[self convertToGVBillsArrayWithParseObjectsArray:userObjectsInGroup]];
            block(userItems, error);
        } else {
            NSString* errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            block(nil, error);
        }
    }];
}

/*
 Convert an array of PFObjects to a mutable array of GVBills.
 */
-(NSMutableArray*)convertToGVBillsArrayWithParseObjectsArray:(NSArray*)objects
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
        GVBills* row = [[GVBills alloc] initWithName:object[@"bill_nm"]
                                                cost:[object[@"cost_nb"] doubleValue]
                                            interval:[object[@"interval_nb"] intValue]
                                         nextPayDate:object[@"nextPayDate"]
                                            boughtBy:boughtByString
                                               group:groupString];
        [userItems addObject: row];
    }
    return userItems;
}

@end
