//
//  GVItemsDAO.h
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVItems.h"
#import "GVParseDAOUtilities.h"
@interface GVItemsDAO : NSObject
@property (weak, nonatomic)GVParseDAOUtilities* sharedGVParseDAOUtilities;
+ (id)sharedGVItemsDAO;
-(void)saveItemInBackgroundWithGVItemWithBlock:(GVItems*)item block:(void (^) (BOOL succeeded, NSError* error) )block;
-(void)queryAllUserItemsWithBlock:(void (^)(NSMutableArray* items, NSError* error) ) block;
-(void)queryGroupItemsWithGroupNameWithBlock:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block;
-(void)queryGroupItemsWithUserNameWithBlock:(NSString*)username group:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block;

@end
