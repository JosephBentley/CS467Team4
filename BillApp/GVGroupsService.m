//
//  GVGroupsService.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/31/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVGroupsService.h"

@implementation GVGroupsService

-(id)init
{
    if (self = [super init]) {
        self.sharedGVGroupsDAO = [GVGroupsDAO sharedGVGroupsDAO];
    }
    return self;
}

-(void)createNewGroupWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
    [self.sharedGVGroupsDAO createNewGroupWithGroupNameWithBlock:group block:block];
}

-(void)inviteToGroupWithUserNameWithBlock:(NSString*)username groupName:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
    [self.sharedGVGroupsDAO inviteToGroupWithUserNameWithBlock:username group:group block:block];
}

-(void)declineInviteWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
    [self.sharedGVGroupsDAO declineInviteWithGroupNameWithBlock:group block:block];
}

-(void)acceptInviteWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
    [self.sharedGVGroupsDAO acceptInviteWithGroupNameWithBlock:group block:block];
}

-(void)acceptGroupJoinRequestFromUserWithBlock:(NSString*)username group:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
    [self.sharedGVGroupsDAO acceptGroupJoinRequestFromUserWithBlock:username group:group block:block];
}

-(void)joinGroupWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
    [self.sharedGVGroupsDAO joinGroupWithGroupNameWithBlock:group block:block];
}

-(void)leaveGroupWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block
{
    [self.sharedGVGroupsDAO leaveGroupWithGroupNameWithBlock:group block:block];
}

-(void)queryInvitedToGroupsWithBlock:(void (^) (NSMutableArray* groupInvites, NSError* error)) block
{
    [self.sharedGVGroupsDAO queryInvitedToGroupsWithBlock:block];
}

-(void)queryUserJoinedGroupsWithBlock:(void (^) (NSMutableArray* groupsJoined, NSError* error)) block
{
    [self.sharedGVGroupsDAO queryUserJoinedGroupsWithBlock:block];
}

@end
