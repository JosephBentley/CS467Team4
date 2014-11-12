//
//  GVPaymentsService.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVPaymentsService.h"

@implementation GVPaymentsService

-(id) init
{
    if (self = [super init]){
        self.sharedGVPaymentsDAO = [GVPaymentsDAO sharedGVPaymentsDAO];
    }
    return self;
}

-(void)savePaymentInBackgroundWithGVPaymentsWithBlock:(GVPayments*)payment block:(void (^) (BOOL succeeded, NSError* error)) block
{
    if (payment.name != nil && payment.total >= 0 && payment.interestRate >= 0 && payment.interval >= 0 && payment.nextPayDate != nil) {
        [self.sharedGVPaymentsDAO savePaymentInBackgroundWithGVPaymentsWithBlock:payment block:^(BOOL succeeded, NSError* error){
            if (succeeded && !error) {
                block(succeeded, error);
            }
            else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@", errorString);
                block(succeeded, [NSError errorWithDomain:@"com.gvsu.edu" code:-402 userInfo:[error userInfo]]);
                //block(succeeded, [[NSError alloc] initWithDomain:@"com.gvsu.edu" code:-400 userInfo:[error userInfo]]);
            }
        }];
    } else {
        block(FALSE, [[NSError alloc] initWithDomain:@"com.gvsu.edu" code:-402 userInfo:[[NSDictionary alloc]init]]);
    }
}

-(void)queryAllUserPaymentsWithBlock:(void (^)(NSMutableArray* items, NSError* error) ) block
{
    [self.sharedGVPaymentsDAO queryAllUserPaymentsWithBlock:block];
}

-(void)queryGroupPaymentsWithGroupNameWithBlock:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVPaymentsDAO queryGroupPaymentsWithGroupNameWithBlock:groupname block:block];
}

-(void)queryGroupPaymentsWithUserNameWithBlock:(NSString*)username group:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVPaymentsDAO queryGroupPaymentsWithUserNameWithBlock:username group:groupname block:block];
}

@end
