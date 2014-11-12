//
//  GVBillsDAO.h
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVBills.h"
#import "GVParseDAOUtilities.h"

@interface GVBillsDAO : NSObject
@property (weak, nonatomic)GVParseDAOUtilities* sharedGVParseDAOUtilities;
+ (id)sharedGVBillsDAO;
-(void)saveBillInBackgroundWithGVBillsWithBlock:(GVBills*)bill block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)queryAllUserBillsWithBlock:(void (^)(NSMutableArray* items, NSError* error) ) block;
-(void)queryGroupBillsWithGroupNameWithBlock:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block;
-(void)queryGroupBillsWithUserNameWithBlock:(NSString*)username group:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block;
@end
