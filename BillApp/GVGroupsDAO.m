//
//  GVGroupsDAO.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/31/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVGroupsDAO.h"
#import "GVGroups.h"
#import <Parse/Parse.h>

static NSString* GROUPS_TABLE_NAME = @"Groups";
static NSString* GROUP_INVITES_TABLE_NAME = @"GroupInvites";
static NSString* BOUGHT_BY_COLUMN_NAME = @"boughtBy";

@implementation GVGroupsDAO

#pragma mark Singleton Methods

+ (id)sharedGVGroupsDAO {
    static GVGroupsDAO *sharedGVGroupsDAO = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGVGroupsDAO = [[self alloc] init];
    });
    return sharedGVGroupsDAO;
}

- (id)init {
    if (self = [super init]) {
        // set queries (or make them static final)
        self.sharedGVUserDAO = [GVUserDAO sharedGVUserDAO];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

#pragma mark Parse Methods

-(void)createNewGroupWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
    PFObject *newGroup = [PFObject objectWithClassName:GROUPS_TABLE_NAME];
    newGroup[@"group_nm"] = group;
    
    newGroup[@"members"] = @[ [PFUser currentUser] ];
    
    
    PFACL *groupACL = [PFACL ACL];
    [groupACL setPublicReadAccess:NO];
    [groupACL setReadAccess:YES forUser:[PFUser currentUser]];
    [groupACL setWriteAccess:YES forUser:[PFUser currentUser]];
    newGroup.ACL = groupACL;
    [newGroup saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
        PFObject *newGroupInvites = [PFObject objectWithClassName:GROUP_INVITES_TABLE_NAME];
        newGroupInvites[@"group_nm"] = group;
        
        newGroupInvites[@"members"] = @[ [PFUser currentUser] ];
        
        
        //newGroupInvites[@"group_object_id"] = newGroup[@"objectId"];
        PFACL *invitesACL = [PFACL ACL];
        [invitesACL setPublicReadAccess:NO];
        [invitesACL setReadAccess:YES forUser:[PFUser currentUser]];
        [invitesACL setWriteAccess:YES forUser:[PFUser currentUser]];
        newGroupInvites.ACL = invitesACL;
        //        [newGroupInvites saveInBackgroundWithBlock:block];
        [newGroupInvites saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error) {
            [newGroup setObject:newGroupInvites forKey:@"invites"];
            [newGroup saveInBackgroundWithBlock:block];
        }];
    }];
}

-(void)inviteToGroupWithUserNameWithBlock:(NSString*)username group:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
    [self.sharedGVUserDAO queryForUserWithUserNameWithBlock:username block:^(PFObject* object, NSError* error) {
        if (!error) {
            //PFUser* invitedUser = [[PFUser alloc] initWithClassName:object[@"objectId"]];
            PFUser* invitedUser = (PFUser*)object;
            [self queryForGroupInvitesWithGroupNameWithBlock:group block:^(PFObject *object, NSError *error) {
                if (!error) {
                    NSLog(@"Setting read write permissions on ACL");
                    PFACL* invitesACL = object[@"ACL"];
                    [invitesACL setReadAccess:YES forUser:invitedUser];
                    [invitesACL setWriteAccess:YES forUser:invitedUser];
                    [object saveInBackgroundWithBlock:block];
                    //block(TRUE, error);
                }
                else {
                    NSLog(@"QueryForGroupInvitesWithGroupNameWithBlock failed.\n Group Searched: %@", group);
                    block(FALSE, error);
                }
            }];
        }
        else {
            NSLog(@"queryForUserWithUserNameWithBlock failed");
            block(FALSE, error);
        }
    }];
}

-(void)declineInviteWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
    [self queryForGroupInvitesWithGroupNameWithBlock:group block:^(PFObject *object, NSError *error) {
        if (!error) {
            PFACL* invitesACL = object[@"ACL"];
            [invitesACL setReadAccess:NO forUser:[PFUser currentUser]];
            [invitesACL setWriteAccess:NO forUser:[PFUser currentUser]];
            [object saveInBackgroundWithBlock:block];
            //block(TRUE, error);
        }
        else {
            block(FALSE, error);
        }
    }];
}

-(void)acceptInviteWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
	[self queryForGroupInvitesWithGroupNameWithBlock:group block:^(PFObject* object, NSError* error) {
		if (!error) {
            
            [object[@"members"] addObject:[PFUser currentUser]];
			[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
//                    // removes self from invitesACL on invites table.
//                    [self declineInviteWithGroupNameWithBlock:group block:block];
                    block(TRUE, error);
                }
                else {
                    block(FALSE, error);
                }
            }];
        }
        else {
            block(FALSE, error);
        }
	}];
}

-(void)acceptGroupJoinRequestFromUserWithBlock:(NSString*)username group:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
	[self queryForGroupWithGroupNameWithBlock:group block:^(PFObject* object, NSError* error) {
		if (!error) {
            PFACL* groupACL = object[@"ACL"];
            PFObject* groupObject = object;
            [self.sharedGVUserDAO queryForUserWithUserNameWithBlock:username block:^(PFObject *object, NSError *error) {
                if (!error) {
                    PFUser* user = (PFUser*)object;
                    [groupACL setReadAccess:YES forUser:user];
                    [groupACL setWriteAccess:YES forUser:user];
                    [groupObject[@"members"] addObject:user];
                    
                    [groupObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
//                            // removes self from invitesACL on invites table.
//                            [self declineInviteWithGroupNameWithBlock:group block:block];
                            block(TRUE, error);
                        }
                        else {
                            block(FALSE, error);
                        }
                    }];
                }
                else {
                    block(false, error);
                }
            }];
        }
        else {
            block(FALSE, error);
        }
	}];
}

-(void)joinGroupWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
	[self queryForGroupWithGroupNameWithBlock:group block:^(PFObject* object, NSError* error) {
		if (!error) {
            PFACL* groupACL = object[@"ACL"];
            [groupACL setReadAccess:YES forUser:[PFUser currentUser]];
            [groupACL setWriteAccess:YES forUser:[PFUser currentUser]];
			[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
//                    // removes self from invitesACL on invites table.
//                    [self declineInviteWithGroupNameWithBlock:group block:block];
                    block(TRUE, error);
                }
                else {
                    block(FALSE, error);
                }
            }];
        }
        else {
            block(FALSE, error);
        }
	}];
}

-(void)leaveGroupWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
    NSLog(@"Inside leaveGroupWithGroupNameWithBlock in DAO");
    
    [self queryForGroupInvitesWithGroupNameWithBlock:group block:^(PFObject *object, NSError *error) {
        if (!error) {
            PFACL* invitesACL = object[@"ACL"];
            [invitesACL setReadAccess:NO forUser:[PFUser currentUser]];
            [invitesACL setWriteAccess:NO forUser:[PFUser currentUser]];
            
            NSLog(@"Before deleting a member.");
            int i = 0;
            int locationToRemove = -1;
            for (PFObject* user in object[@"members"]) {
                PFObject* userInGroup = [user fetchIfNeeded];
                if ([userInGroup[@"username"] isEqualToString:[PFUser currentUser][@"username"]]) {
                    locationToRemove = i;
                }
                i++;
            }
            if (locationToRemove != -1) {
                [object[@"members"] removeObjectAtIndex:locationToRemove];
            }
            NSLog(@"After deleting a member.");
            //[object[@"members"] removeObject:(PFObject*)[PFUser currentUser]];
            
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self queryForGroupWithGroupNameWithBlock:group block:^(PFObject* object, NSError* error) {
                    if (!error) {
                        
                        // allow for option to save user data here when leaving group.
                        // User should be allowed to save their data from the group, since they will no longer
                        // have access to it Once they remove their permissions from the ACL.
                        
                        PFACL* groupACL = object[@"ACL"];
                        [groupACL setReadAccess:NO forUser:[PFUser currentUser]];
                        [groupACL setWriteAccess:NO forUser:[PFUser currentUser]];
                        
                        
                        NSLog(@"Before deleting a member.");
                        int i = 0;
                        int locationToRemove = -1;
                        for (PFObject* user in object[@"members"]) {
                            PFObject* userInGroup = [user fetchIfNeeded];
                            if ([userInGroup[@"username"] isEqualToString:[PFUser currentUser][@"username"]]) {
                                locationToRemove = i;
                            }
                            i++;
                        }
                        if (locationToRemove != -1) {
                            [object[@"members"] removeObjectAtIndex:locationToRemove];
                        }
                        NSLog(@"After deleting a member.");
                        
                        //[object[@"members"] removeObject:(PFObject*)[PFUser currentUser]];
                        
                        
                        [object saveInBackgroundWithBlock:block];
                        
                        //block(TRUE, error);
                    }
                    else {
                        block(FALSE, error);
                    }
                }];
            }];
            //block(TRUE, error);
        }
        else {
            block(FALSE, error);
        }
    }];
}

-(void)queryInvitedToGroupsWithBlock:(void (^) (NSMutableArray* groupsInvitedTo, NSError* error)) block
{
    PFQuery *query = [PFQuery queryWithClassName:GROUP_INVITES_TABLE_NAME];
    NSMutableArray* invitedToGroups = [[NSMutableArray alloc] init];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                if (![object[@"members"] containsObject:[PFUser currentUser]])
                    [invitedToGroups addObject: object[@"group_nm"]];
            }
            block(invitedToGroups, error);
        } else {
            NSString* errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
			block(invitedToGroups, error);
        }
    }];
}

-(void)queryUserJoinedGroupsWithBlock:(void (^) (NSMutableArray* groupsJoined, NSError* error)) block
{
    PFQuery *query = [PFQuery queryWithClassName:GROUPS_TABLE_NAME];
    NSMutableArray* invitedToGroups = [[NSMutableArray alloc] init];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSMutableArray* userArray;
                for (PFObject *object2 in object[@"users"]){
                    [userArray addObject:object2[@"username"]];
                }
                GVGroups* row = [[GVGroups alloc] initWithName:object[@"group_nm"] users:userArray];
                [invitedToGroups addObject: row];
            }
            block(invitedToGroups, error);
        } else {
            NSString* errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
			block(invitedToGroups, error);
        }
    }];
}

-(void)queryForGroupWithGroupNameWithBlock:(NSString*)group block:(void (^) (PFObject* object, NSError* error )) block
{
    PFQuery *query = [PFQuery queryWithClassName:GROUPS_TABLE_NAME];
    [query whereKey:@"group_nm" equalTo:group];
    [query getFirstObjectInBackgroundWithBlock:block];
}

-(void)queryForGroupInvitesWithGroupNameWithBlock:(NSString*)group block:(void (^) (PFObject* object, NSError* error )) block
{
    PFQuery *query = [PFQuery queryWithClassName:GROUP_INVITES_TABLE_NAME];
    [query whereKey:@"group_nm" equalTo:group];
    [query getFirstObjectInBackgroundWithBlock:block];
}

@end
