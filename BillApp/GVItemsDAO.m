//
//  GVItemsDAO.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVItemsDAO.h"
#import "GVGroupsDAO.h"
#import "GVUserDAO.h"
#import <Parse/Parse.h>

static NSString* ITEMS_TABLE_NAME = @"IndividualItems";
static NSString* GROUPS_COLUMN_NAME = @"group";
static NSString* BOUGHT_BY_COLUMN_NAME = @"boughtBy";


@implementation GVItemsDAO

#pragma mark Singleton Methods

+ (id)sharedGVItemsDAO {
    static GVItemsDAO *sharedGVItemsDAO = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGVItemsDAO = [[self alloc] init];
    });
    return sharedGVItemsDAO;
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

-(void)saveItemInBackgroundWithGVItemWithBlock:(GVItems*)item block:(void (^) (BOOL succeeded, NSError* error) )block
{
    NSNumber* nsCost = [[NSNumber alloc] initWithDouble:item.cost];
    PFObject *itemObject = [PFObject objectWithClassName:ITEMS_TABLE_NAME];
    itemObject[@"item_nm"] = item.name;
    itemObject[@"cost_nb"] = nsCost;
    itemObject[@"productID_nm"] = item.productID;
    itemObject[@"shared_f"] = item.sharedFlag;
    
    [self.sharedGVParseDAOUtilities saveObjectInBackgroundWithUserNameWithBlock:[PFUser currentUser][@"username"] group:item.group object:itemObject boughtByColumnName:BOUGHT_BY_COLUMN_NAME groupsColumnName:GROUPS_COLUMN_NAME block:block];
}


/*
 Get all user items.
 */
-(void)queryAllUserItemsWithBlock:(void (^)(NSMutableArray* items, NSError* error) ) block
{
    PFQuery *query = [PFQuery queryWithClassName:ITEMS_TABLE_NAME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray* userItems = [[NSMutableArray alloc] initWithArray:[self convertToGVItemsArrayWithParseObjectsArray:objects]];
            block(userItems, error);
        } else {
            NSString* errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
			block(nil, error);
        }
    }];
}

/*
 Get all group items.
 */
-(void)queryGroupItemsWithGroupNameWithBlock:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVParseDAOUtilities queryGroupObjectsWithGroupNameWithBlock:groupname table:ITEMS_TABLE_NAME block:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray* userItems = [[NSMutableArray alloc] initWithArray:[self convertToGVItemsArrayWithParseObjectsArray:objects]];
            block(userItems, error);
        } else {
            NSString* errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            block(nil, error);
        }
    }];
}

/*
 Get all group items bought by a certain user.
 */
-(void)queryGroupItemsWithUserNameWithBlock:(NSString*)username group:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVParseDAOUtilities queryGroupObjectsWithUserNameWithBlock:username group:groupname table:ITEMS_TABLE_NAME block:^(NSArray *userObjectsInGroup, NSError *error) {
        if (!error) {
            NSMutableArray* userItems = [[NSMutableArray alloc] initWithArray:[self convertToGVItemsArrayWithParseObjectsArray:userObjectsInGroup]];
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
-(NSMutableArray*)convertToGVItemsArrayWithParseObjectsArray:(NSArray*)objects
{
    NSLog(@"Successfully retrieved %d items.", objects.count);
    NSMutableArray* userItems = [[NSMutableArray alloc] init];
    for (PFObject *object in objects) {
        double cost = [object[@"cost_nb"] doubleValue];
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
        GVItems* row = [[GVItems alloc] initWithName:object[@"item_nm"]
                                                cost:cost productID:object[@"productId_nm"]
                                          sharedItem:object[@"shared_f"]
                                            boughtBy:boughtByString
                                               group:groupString];
        [userItems addObject: row];
    }
    return userItems;
}

@end
