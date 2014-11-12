//
//  GVBillsService.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVBillsService.h"

@implementation GVBillsService

-(id) init
{
    if (self = [super init]){
        self.sharedGVBillsDAO = [GVBillsDAO sharedGVBillsDAO];
        
    }
    return self;
}

-(void)saveBillInBackgroundWithGVBillsWithBlock:(GVBills*)bill block:(void (^) (BOOL succeeded, NSError* error)) block
{
    GVBillsDAO* sharedGVBillsDAO = [GVBillsDAO sharedGVBillsDAO];
    if (bill.name != nil && bill.cost >= 0 && bill.interval >= 0 && bill.nextPayDate != nil) {
        [sharedGVBillsDAO saveBillInBackgroundWithGVBillsWithBlock:bill block:^(BOOL succeeded, NSError* error) {
            if (succeeded && !error) {
                block(succeeded, error);
            }
            else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@", errorString);
                block(succeeded, [NSError errorWithDomain:@"com.gvsu.edu" code:-401 userInfo:[error userInfo]]);
            }
        }];
    } else {
        block(FALSE, [[NSError alloc] initWithDomain:@"com.gvsu.edu" code:-400 userInfo:[[NSDictionary alloc]init]]);
    }
}

-(void)queryAllUserBillsWithBlock:(void (^)(NSMutableArray* items, NSError* error) ) block
{
    [self.sharedGVBillsDAO queryAllUserBillsWithBlock:block];
}

-(void)queryGroupBillsWithGroupNameWithBlock:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVBillsDAO queryGroupBillsWithGroupNameWithBlock:groupname block:block];
}

-(void)queryGroupBillsWithUserNameWithBlock:(NSString*)username group:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVBillsDAO queryGroupBillsWithUserNameWithBlock:username group:groupname block:block];
}

@end
