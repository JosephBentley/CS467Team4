//
//  GVPaymentsDAO.h
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVPayments.h"
#import "GVParseDAOUtilities.h"

@interface GVPaymentsDAO : NSObject
@property (weak, nonatomic)GVParseDAOUtilities* sharedGVParseDAOUtilities;
+ (id)sharedGVPaymentsDAO;
-(void)savePaymentInBackgroundWithGVPaymentsWithBlock:(GVPayments*)payment block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)queryAllUserPaymentsWithBlock:(void (^)(NSMutableArray* items, NSError* error) ) block;
-(void)queryGroupPaymentsWithGroupNameWithBlock:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block;
-(void)queryGroupPaymentsWithUserNameWithBlock:(NSString*)username group:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block;


@end
