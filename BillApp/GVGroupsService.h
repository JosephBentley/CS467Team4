//
//  GVGroupsService.h
//  ParseLogInAttempt
//
//  Created by X Code User on 10/31/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVGroupsDAO.h"

@interface GVGroupsService : NSObject
@property (weak, nonatomic) GVGroupsDAO* sharedGVGroupsDAO;
-(void)createNewGroupWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)inviteToGroupWithUserNameWithBlock:(NSString*)username groupName:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)declineInviteWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)acceptInviteWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)joinGroupWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)leaveGroupWithGroupNameWithBlock:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)declineGroupJoinRequestFromUserWithBlock:(NSString*)username group:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)acceptGroupJoinRequestFromUserWithBlock:(NSString*)username group:(NSString*)group block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)queryInvitedToGroupsWithBlock:(void (^) (NSMutableArray* groupsJoined, NSError* error)) block;
-(void)queryUserJoinedGroupsWithBlock:(void (^) (NSMutableArray* groupsJoined, NSError* error)) block;
-(void)queryPendingJoinRequestsWithGroupNameWithBlock:(NSString*)group block:(void (^) (NSMutableArray* object, NSError* error)) block;
@end
