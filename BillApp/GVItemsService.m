//
//  GVItemsService.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/16/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVItemsService.h"

@implementation GVItemsService

-(id) init
{
    if (self = [super init]){
        self.sharedGVItemsDAO = [GVItemsDAO sharedGVItemsDAO];
    }
    return self;
}

-(void)saveItemInBackgroundWithGVItemWithBlock:(GVItems*)item block:(void (^) (BOOL succeeded, NSError* error) )block;
{
    if (item.name != nil && item.cost >= 0 && item.productID != nil && item.sharedFlag >= 0){
        [self.sharedGVItemsDAO saveItemInBackgroundWithGVItemWithBlock:item block:^(BOOL succeeded, NSError* error) {
            if(succeeded && !error) {
                // business logic checks not necessary
                block(succeeded, error);
            }
            else {
                //set custom error message to send to control block below?
                NSLog(@"Something went wrong in DAO layer.");
                block(succeeded, error);
            }
        }];
    }
    else{
        //NSError* error = [[NSError alloc] initWithDomain:@"com.gvsu.edu" code:-400 userInfo:[[NSDictionary alloc]init]];
        NSLog(@"A value was not set correctly in the view controller.");
        block(FALSE, [[NSError alloc] initWithDomain:@"com.gvsu.edu" code:-400 userInfo:[[NSDictionary alloc]init]]);
    }
}

-(void)getAllUserItemsUsingBlock:(void (^)(NSMutableArray* items, NSError* error) ) block;
{
    [self.sharedGVItemsDAO queryAllUserItemsWithBlock:^(NSMutableArray* items, NSError* error) {
        if (!error) {
            
            block(items, error);
        }
        else {
            
        }
    }];
}

-(void)queryUserItemsWithGroupNameWithBlock:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVItemsDAO queryAllUserItemsWithBlock:block];
}

-(void)queryGroupItemsWithGroupNameWithBlock:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVItemsDAO queryGroupItemsWithGroupNameWithBlock:groupname block:block];
}

-(void)queryGroupItemsWithUserNameWithBlock:(NSString*)username group:(NSString*)groupname block:(void (^) (NSMutableArray* userItemsInGroup, NSError* error)) block
{
    [self.sharedGVItemsDAO queryGroupItemsWithUserNameWithBlock:username group:groupname block:block];
}


@end