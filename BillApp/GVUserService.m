//
//  GVUserService.m
//  ParseLogInAttempt
//
//  Created by X Code User on 10/26/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import "GVUserService.h"

@implementation GVUserService

-(id) init
{
    if (self = [super init]) {
        self.sharedGVUserDAO = [GVUserDAO sharedGVUserDAO];
    }
    return self;
}

-(void)createNewUserWithUserNameWithBlock:(NSString*)username password:(NSString*)password email:(NSString*)email block:(void (^) (BOOL succeeded, NSError* error)) block
{
    if (username != nil && password != nil && email != nil) {
        [self.sharedGVUserDAO createNewUserWithUserNameWithBlock:username password:password email:email block:^(BOOL succeeded, NSError* error) {
            if (!error) {
                block(succeeded, error);
            }
            else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@", errorString);
                // Show the errorString somewhere and let the user try again.
                block(succeeded, [[NSError alloc] initWithDomain:@"com.gvsu.edu" code:-400 userInfo:[error userInfo]]);
            }
        }];
    }
    else {
        block(FALSE, [[NSError alloc] initWithDomain:@"com.gvsu.edu" code:-400 userInfo:[[NSDictionary alloc]init]]);
    }
}

-(void)logInWithUsernameInBackgroundWithBlock:(NSString*)username password:(NSString*)password block:(void (^) (NSError* error) ) block
{
    if (username != nil && password != nil) {
        [self.sharedGVUserDAO logInWithUsernameInBackgroundWithBlock:username password:password block:^(NSError* error){
            if (!error) {
                block(error);
            }
            else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@", errorString);
                block([NSError errorWithDomain:@"com.gvsu.edu" code:-400 userInfo:[error userInfo]]);
                // Show the errorString somewhere and let the user try again.
            }
        }];
    }
    else {
        block([[NSError alloc] initWithDomain:@"com.gvsu.edu" code:-400 userInfo:[[NSDictionary alloc]init]]);
    }
}

-(void)logoutCurrentUserWithError:(NSError **) error
{
	[self.sharedGVUserDAO logoutCurrentUser];
}

-(void)resetPasswordWithEmailAddressWithBlock:(NSString*)email block:(void (^) (BOOL succeeded, NSError* error)) block
{
	[self.sharedGVUserDAO resetPasswordWithEmailAddressWithBlock:email block:block];
}

@end