//
//  GVParseUtilities.m
//  ParseLogInAttempt
//
//  Created by X Code User on 11/10/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVParseDAOUtilities.h"
#import "Parse/Parse.h"

@implementation GVParseDAOUtilities

#pragma mark Singleton Methods

+ (id)sharedGVParseDAOUtilities {
    static GVParseDAOUtilities *sharedGVParseDAOUtilities = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGVParseDAOUtilities = [[self alloc] init];
    });
    return sharedGVParseDAOUtilities;
}

- (id)init {
    if (self = [super init]) {
        // set queries (or make them static final)
        self.sharedGVGroupsDAO = [GVGroupsDAO sharedGVGroupsDAO];
        self.sharedGVUserDAO = [GVUserDAO sharedGVUserDAO];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

#pragma mark - Parse methods

-(void)saveObjectInBackgroundWithUserNameWithBlock:(NSString*)username group:(NSString*)groupName object:(PFObject*)itemObject
                                boughtByColumnName:(NSString*)BOUGHT_BY_COLUMN_NAME groupsColumnName:(NSString*)GROUPS_COLUMN_NAME block:(void (^) (BOOL succeeded, NSError* error)) block
{
    PFACL* acl = [PFACL ACL];
    [acl setPublicReadAccess:TRUE];
    [acl setPublicWriteAccess:TRUE];
    itemObject.ACL = acl;
    if (username != nil){
        [self.sharedGVUserDAO queryForUserWithUserNameWithBlock:username block:^(PFObject *object, NSError *error) {
            [itemObject setObject:object forKey:BOUGHT_BY_COLUMN_NAME];
            if (groupName != nil) {
                [self.sharedGVGroupsDAO queryForGroupWithGroupNameWithBlock:groupName block:^(PFObject *object, NSError *error) {
                    [itemObject setObject:object forKey:GROUPS_COLUMN_NAME];
                    [itemObject saveInBackgroundWithBlock:block];
                }];
            }
            else {
                NSNull* nsNull;
                [itemObject setObject:nsNull forKey:GROUPS_COLUMN_NAME];
                [itemObject saveInBackgroundWithBlock:block];
            }
        }];
    }
    else {
        [itemObject setObject:[PFUser currentUser] forKey:BOUGHT_BY_COLUMN_NAME];
        if (groupName != nil) {
            [self.sharedGVGroupsDAO queryForGroupWithGroupNameWithBlock:groupName block:^(PFObject *object, NSError *error) {
                [itemObject setObject:object forKey:GROUPS_COLUMN_NAME];
                [itemObject saveInBackgroundWithBlock:block];
            }];
        }
        else {
            [itemObject saveInBackgroundWithBlock:block];
        }
    }
}

-(void)queryAllUserObjectsWithTableNameWithBlock:(NSString*)tableName block:(void (^)(NSArray* objects, NSError* error) ) block
{
    PFQuery *query = [PFQuery queryWithClassName:tableName];
    [query findObjectsInBackgroundWithBlock:block];
}

-(void)queryGroupObjectsWithGroupNameWithBlock:(NSString*)group table:(NSString*)tableName block:(void (^) (NSArray* userObjectsInGroup, NSError* error)) block
{
	[self.sharedGVGroupsDAO queryForGroupWithGroupNameWithBlock:group block:^(PFObject* object, NSError* error) {
        PFQuery *query = [PFQuery queryWithClassName:tableName];
        [query whereKey:@"group" equalTo:object];
        [query findObjectsInBackgroundWithBlock:block];
    }];
}

-(void)queryGroupObjectsWithUserNameWithBlock:(NSString*)username group:(NSString*)groupname table:(NSString*)tableName block:(void (^) (NSArray* userObjectsInGroup, NSError* error)) block
{
	[self.sharedGVGroupsDAO queryForGroupWithGroupNameWithBlock: groupname block:^(PFObject* object, NSError* error) {
        PFQuery *query = [PFQuery queryWithClassName:tableName];
        [query whereKey:@"group" equalTo:object];
        [self.sharedGVUserDAO queryForUserWithUserNameWithBlock:username block:^(PFObject *object, NSError *error) {
            [query whereKey:@"boughtBy" equalTo:object];
            [query findObjectsInBackgroundWithBlock:block];
        }];
    }];
}

@end
