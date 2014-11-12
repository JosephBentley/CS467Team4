//
//  GVParseUtilities.h
//  ParseLogInAttempt
//
//  Created by X Code User on 11/10/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "GVGroupsDAO.h"
#import "GVUserDAO.h"

@interface GVParseDAOUtilities : NSObject
@property (weak, nonatomic)GVGroupsDAO* sharedGVGroupsDAO;
@property (weak, nonatomic)GVUserDAO* sharedGVUserDAO;
-(void)saveObjectInBackgroundWithUserNameWithBlock:(NSString*)username group:(NSString*)groupName object:(PFObject*)itemObject
                                boughtByColumnName:(NSString*)BOUGHT_BY_COLUMN_NAME groupsColumnName:(NSString*)GROUPS_COLUMN_NAME block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)queryAllUserObjectsWithTableNameWithBlock:(NSString*)tableName block:(void (^)(NSArray* objects, NSError* error) ) block;
-(void)queryGroupObjectsWithGroupNameWithBlock:(NSString*)group table:(NSString*)tableName block:(void (^) (NSArray* userObjectsInGroup, NSError* error)) block;
-(void)queryGroupObjectsWithUserNameWithBlock:(NSString*)username group:(NSString*)groupname table:(NSString*)tableName block:(void (^) (NSArray* userObjectsInGroup, NSError* error)) block;
+ (id)sharedGVParseDAOUtilities;
@end
