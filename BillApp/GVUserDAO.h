//
//  GVUserDAO.h
//  ParseLogInAttempt
//
//  Created by X Code User on 10/26/14.
//  Copyright (c) 2014 CS467. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GVUserDAO : NSObject
+ (id)sharedGVUserDAO;
-(void)createNewUserWithUserNameWithBlock:(NSString*)username password:(NSString*)password email:(NSString*)email block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)logInWithUsernameInBackgroundWithBlock:(NSString*)username password:(NSString*)password block:(void (^) (NSError* error) ) block;
-(bool)logoutCurrentUser;
-(void)resetPasswordWithEmailAddressWithBlock:(NSString*)email block:(void (^) (BOOL succeeded, NSError* error)) block;
-(void)queryForUserWithUserNameWithBlock:(NSString*)username block:(void (^) (PFObject* object, NSError* error)) block;
@end